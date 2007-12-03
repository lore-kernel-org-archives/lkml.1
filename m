Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbXLCGYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbXLCGYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 01:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbXLCGX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 01:23:56 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:48631 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbXLCGXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 01:23:54 -0500
Message-ID: <4753A025.2020803@ak.jp.nec.com>
Date: Mon, 03 Dec 2007 15:20:21 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morgan <morgan@kernel.org>
CC: KaiGai Kohei <kaigai@kaigai.gr.jp>, serge@hallyn.com,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] capabilities: introduce per-process capability	bounding
 set (v10)
References: <20071126200908.GA13287@sergelap.austin.ibm.com> <4750B6D5.7070607@kaigai.gr.jp> <20071201035820.GA7730@vino.hallyn.com> <4751B1C3.1000704@kernel.org> <475226B1.5090303@kaigai.gr.jp> <4752F63B.6070606@kernel.org>
In-Reply-To: <4752F63B.6070606@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> KaiGai Kohei wrote:
>>> There is already a pam_cap module in the libcap2 package. Can we merge
>>> this functionality?
>> I think it is a good idea.
>>
>> However, this module already have a feature to modify inheritable
>> capability set.
>> How does it to be described in the "/etc/security/capability.conf"?
>>
>> One idea is like a following convention:
>>
>> # compatible configuration. We can omit "i:" at the head of line
>> cap_setfcap                 tak
>> # It drops any capabilities from b-set except for cap_net_raw and
>> cap_fowner
>> b:cap_net_raw,cap_fowner    ymj
>> # It drops only cap_dac_override from b-set.
>> b:-cap_dac_override         kaigai
>> # It drops only cap_sys_admin from b-set of any user within users group.
>> b:-cap_sys_admin            group:users
> 
> I like the idea of a separate line for bounds.
> 
> For ease of parsing, perhaps '!' or some other symbol prefix to the line
> could be used to identify lines that refer to cap_bound?
> 
> In other modules, @groupname is used to capture a group association.
> 
> Lines like this should be supported:
> 
> !cap_net_raw         @regularusers    # suppress from cap_bset
> cap_net_raw          @pingers morgan  # add to pI
> 
> where morgan is not in group @pingers but is in group @regularusers.

The "@groupname" is intuitive convention. I also think it is good idea.

But !cap_xxx is a bit misunderstandable for me. Someone may misunderstand
this line means any capabilities except for cap_xxx.
Thus, I think that using "b:" and omittable "i:" prefix is better than "!".
In addition, what is your opinion about using "-b:" and "-i:" to represent
dropping capabilities currently they have?

There is one more uncertain case.
When a user belongs to several groups with capabilities configuration,
what capabilities are to be attached for the user?

e.g) When kaigai belong to @pingers and @paccters

b:cap_sys_pacct		@paccters
b:cap_net_raw		@pingers
-b:cap_dac_override,cap_net_raw		kaigai

If we apply "OR" policy, kaigai get only cap_sys_pacct, because
he got cap_sys_pacct and cap_net_raw came from @paccters and @pingers
but cap_dac_override and cap_net_raw are dropped by the third line.

Thanks,

> Cheers
> 
> Andrew
> 
>> Thanks,
>>
>>> Cheers
>>>
>>> Andrew
>>>
>>> serge@hallyn.com wrote:
>>>> Quoting KaiGai Kohei (kaigai@kaigai.gr.jp):
>>>>> Serge E. Hallyn wrote:
>>>>>> The capability bounding set is a set beyond which capabilities
>>>>>> cannot grow.  Currently cap_bset is per-system.  It can be
>>>>>> manipulated through sysctl, but only init can add capabilities.
>>>>>> Root can remove capabilities.  By default it includes all caps
>>>>>> except CAP_SETPCAP.
>>>>> Serge,
>>>>>
>>>>> This feature makes me being interested in.
>>>>> I think you intend to apply this feature for the primary process
>>>>> of security container.
>>>>> However, it is also worthwhile to apply when a session is starting up.
>>>>>
>>>>> The following PAM module enables to drop capability bounding bit
>>>>> specified by the fifth field in /etc/passwd entry.
>>>>> This code is just an example now, but considerable feature.
>>>>>
>>>>> build and install:
>>>>> # gcc -Wall -c pam_cap_drop.c
>>>>> # gcc -Wall -shared -Xlinker -x -o pam_cap_drop.so pam_cap_drop.o -lpam
>>>>> # cp pam_cap_drop.so /lib/security
>>>>>
>>>>> modify /etc/passwd as follows:
>>>>>
>>>>> tak:x:1004:100:cap_drop=cap_net_raw,cap_chown:/home/tak:/bin/bash
>>>>>                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>> example:
>>>>> [kaigai@masu ~]$ ping 192.168.1.1
>>>>> PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
>>>>> 64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=1.23 ms
>>>>> 64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=1.02 ms
>>>>>
>>>>> --- 192.168.1.1 ping statistics ---
>>>>> 2 packets transmitted, 2 received, 0% packet loss, time 999ms
>>>>> rtt min/avg/max/mdev = 1.023/1.130/1.237/0.107 ms
>>>>>
>>>>> [kaigai@masu ~]$ ssh tak@localhost
>>>>> tak@localhost's password:
>>>>> Last login: Sat Dec  1 10:09:29 2007 from masu.myhome.cx
>>>>> [tak@masu ~]$ export LANG=C
>>>>> [tak@masu ~]$ ping 192.168.1.1
>>>>> ping: icmp open socket: Operation not permitted
>>>>>
>>>>> [tak@masu ~]$ su
>>>>> Password:
>>>>> pam_cap_bset[6921]: user root does not have 'cap_drop=' property
>>>>> [root@masu tak]# cat /proc/self/status | grep ^Cap
>>>>> CapInh: 0000000000000000
>>>>> CapPrm: 00000000ffffdffe
>>>>> CapEff: 00000000ffffdffe
>>>>> [root@masu tak]#
>>>> Neat.  A bigger-stick version of not adding the account to
>>>> group wheel.  I'll use that.
>>>>
>>>> Is there any reason not to have a separate /etc/login.capbounds
>>>> config file, though, so the account can still have a full name?
>>>> Did you only use that for convenience of proof of concept, or
>>>> is there another reason?
>>>>
>>>>> # BTW, I replaced the James's address in the Cc: list,
>>>>> # because MTA does not accept it.
>>>> Thanks!  I don't know what happened to my alias for him...
>>>>
>>>> thanks,
>>>> -serge
>>>>
>>>>> -- 
>>>>> KaiGai Kohei <kaigai@kaigai.gr.jp>
>>>>>
>>>>> ************************************************************
>>>>>     pam_cap_drop.c
>>>>> ************************************************************
>>>>>
>>>>> /*
>>>>>  * pam_cap_drop.c module -- drop capabilities bounding set
>>>>>  *
>>>>>  * Copyright: 2007 KaiGai Kohei <kaigai@kaigai.gr.jp>
>>>>>  */
>>>>>
>>>>> #include <errno.h>
>>>>> #include <pwd.h>
>>>>> #include <stdlib.h>
>>>>> #include <stdio.h>
>>>>> #include <string.h>
>>>>> #include <syslog.h>
>>>>> #include <sys/prctl.h>
>>>>> #include <sys/types.h>
>>>>>
>>>>> #include <security/pam_modules.h>
>>>>>
>>>>> #ifndef PR_CAPBSET_DROP
>>>>> #define PR_CAPBSET_DROP 24
>>>>> #endif
>>>>>
>>>>> static char *captable[] = {
>>>>>     "cap_chown",
>>>>>     "cap_dac_override",
>>>>>     "cap_dac_read_search",
>>>>>     "cap_fowner",
>>>>>     "cap_fsetid",
>>>>>     "cap_kill",
>>>>>     "cap_setgid",
>>>>>     "cap_setuid",
>>>>>     "cap_setpcap",
>>>>>     "cap_linux_immutable",
>>>>>     "cap_net_bind_service",
>>>>>     "cap_net_broadcast",
>>>>>     "cap_net_admin",
>>>>>     "cap_net_raw",
>>>>>     "cap_ipc_lock",
>>>>>     "cap_ipc_owner",
>>>>>     "cap_sys_module",
>>>>>     "cap_sys_rawio",
>>>>>     "cap_sys_chroot",
>>>>>     "cap_sys_ptrace",
>>>>>     "cap_sys_pacct",
>>>>>     "cap_sys_admin",
>>>>>     "cap_sys_boot",
>>>>>     "cap_sys_nice",
>>>>>     "cap_sys_resource",
>>>>>     "cap_sys_time",
>>>>>     "cap_sys_tty_config",
>>>>>     "cap_mknod",
>>>>>     "cap_lease",
>>>>>     "cap_audit_write",
>>>>>     "cap_audit_control",
>>>>>     "cap_setfcap",
>>>>>     NULL,
>>>>> };
>>>>>
>>>>>
>>>>> PAM_EXTERN int
>>>>> pam_sm_open_session(pam_handle_t *pamh, int flags,
>>>>>                     int argc, const char **argv)
>>>>> {
>>>>>     struct passwd *pwd;
>>>>>     char *pos, *buf;
>>>>>     char *username = NULL;
>>>>>
>>>>>     /* open system logger */
>>>>>     openlog("pam_cap_bset", LOG_PERROR | LOG_PID, LOG_AUTHPRIV);
>>>>>
>>>>>     /* get the unix username */
>>>>>     if (pam_get_item(pamh, PAM_USER, (void *) &username) !=
>>>>> PAM_SUCCESS || !username)
>>>>>         return PAM_USER_UNKNOWN;
>>>>>
>>>>>     /* get the passwd entry */
>>>>>     pwd = getpwnam(username);
>>>>>     if (!pwd)
>>>>>         return PAM_USER_UNKNOWN;
>>>>>
>>>>>     /* Is there "cap_drop=" ? */
>>>>>     pos = strstr(pwd->pw_gecos, "cap_drop=");
>>>>>     if (pos) {
>>>>>         buf = strdup(pos + sizeof("cap_drop=") - 1);
>>>>>         if (!buf)
>>>>>             return PAM_SESSION_ERR;
>>>>>         pos = strtok(buf, ",");
>>>>>         while (pos) {
>>>>>             int rc, i;
>>>>>
>>>>>             for (i=0; captable[i]; i++) {
>>>>>                 if (!strcmp(pos, captable[i])) {
>>>>>                     rc = prctl(PR_CAPBSET_DROP, i);
>>>>>                     if (rc < 0) {
>>>>>                         syslog(LOG_NOTICE, "user %s could not drop
>>>>> %s (%s)",
>>>>>                                username, captable[i], strerror(errno));
>>>>>                         break;
>>>>>                     }
>>>>>                     syslog(LOG_NOTICE, "user %s drops %s\n",
>>>>> username, captable[i]);
>>>>>                     goto next;
>>>>>                 }
>>>>>             }
>>>>>             break;
>>>>>         next:
>>>>>             pos = strtok(NULL, ",");
>>>>>         }
>>>>>         free(buf);
>>>>>     } else {
>>>>>         syslog(LOG_NOTICE, "user %s does not have 'cap_drop='
>>>>> property", username);
>>>>>     }
>>>>>     return PAM_SUCCESS;
>>>>> }
>>>>>
>>>>> PAM_EXTERN int
>>>>> pam_sm_close_session(pam_handle_t *pamh, int flags,
>>>>>                      int argc, const char **argv)
>>>>> {
>>>>>     /* do nothing */
>>>>>     return PAM_SUCCESS;
>>>>> }
>>>>>
>>>>> ************************************************************
>>>>> -
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-security-module" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> -----BEGIN PGP SIGNATURE-----
>>> Version: GnuPG v1.4.7 (Darwin)
>>> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
>>>
>>> iD8DBQFHUbHDmwytjiwfWMwRAj5uAJ9+OB8ljQlJAhKW7jxJWrIPa1k2vgCdHFL9
>>> 3zXtwGz+cVeThb53/kAmdCs=
>>> =OdM7
>>> -----END PGP SIGNATURE-----
>>> -
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-security-module" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.7 (Darwin)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
> 
> iD8DBQFHUvY5+bHCR3gb8jsRAvKaAJ9Upbi+vcSoiQnf64qtubbNow4wmgCdGMBb
> UneHzcT8FDexDcFhN5c6OK4=
> =0XeM
> -----END PGP SIGNATURE-----
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
