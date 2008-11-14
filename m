Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbYKNJWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbYKNJWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 04:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYKNJWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 04:22:23 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:50315 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYKNJWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 04:22:20 -0500
Message-ID: <491D4346.903@nttdata.co.jp>
Date: Fri, 14 Nov 2008 18:22:14 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: haradats@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 06/11] Common functions for TOMOYO
 Linux.
References: <20081104060847.086543472@nttdata.co.jp>	<20081104060951.618445959@nttdata.co.jp> <20081105151221.d605226f.akpm@linux-foundation.org>
In-Reply-To: <20081105151221.d605226f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Nov 2008 09:22:14.0492 (UTC) FILETIME=[7B2639C0:01C9463A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> These functions appear to be implementing more userspace interfaces.
> 
> The userspace interface is the most important part of any kernel code. 
> We can change all the internal details, but the interfaces will live
> forever.
> 
> Hence we should review the proposed interfaces before even looking at
> the code.  Indeed, before even writing the code.
> 
> What are the Tomoyo kernel interfaces?
TOMOYO Linux creates the following files on securityfs (normally 
mounted on /sys/kernel/security) as interfaces between kernel and 
userspace. These files are for TOMOYO Linux management tools *only*, 
not for general programs.

  * profile
  * exception_policy
  * domain_policy
  * manager
  * meminfo
  * self_domain
  * version
  * .domain_status
  * .process_status

*** /sys/kernel/security/tomoyo/profile ***

This file is used to read or write profiles.

"profile" means a running mode of process. A profile lists up 
functions and their modes in "$number-$variable=$value" format. The 
$number is profile number between 0 and 255. Each domain is assigned 
one profile. To assign profile to domains, use "ccs-setprofile" or 
"ccs-editpolicy" or "ccs-loadpolicy" commands.

(Example)
[root@tomoyo]# cat /sys/kernel/security/tomoyo/profile
0-COMMENT=-----Disabled Mode-----
0-MAC_FOR_FILE=disabled
0-MAX_ACCEPT_ENTRY=2048
0-TOMOYO_VERBOSE=disabled
1-COMMENT=-----Learning Mode-----
1-MAC_FOR_FILE=learning
1-MAX_ACCEPT_ENTRY=2048
1-TOMOYO_VERBOSE=disabled
2-COMMENT=-----Permissive Mode-----
2-MAC_FOR_FILE=permissive
2-MAX_ACCEPT_ENTRY=2048
2-TOMOYO_VERBOSE=enabled
3-COMMENT=-----Enforcing Mode-----
3-MAC_FOR_FILE=enforcing
3-MAX_ACCEPT_ENTRY=2048
3-TOMOYO_VERBOSE=enabled

- MAC_FOR_FILE:
Specifies access control level regarding file access requests.
- MAX_ACCEPT_ENTRY:
Limits the max number of ACL entries that are automatically appended 
during learning mode. Default is 2048.
- TOMOYO_VERBOSE:
Specifies whether to print domain policy violation messages or not.

*** /sys/kernel/security/tomoyo/manager ***

This file is used to read or append the list of programs or domains 
that can write to /sys/kernel/security/tomoyo interface. By default, 
only processes with both UID = 0 and EUID = 0 can modify policy via 
/sys/kernel/security/tomoyo interface. You can use keyword 
"manage_by_non_root" to allow policy modification by non root user.

(Example)
[root@tomoyo]# cat /sys/kernel/security/tomoyo/manager
/usr/lib/ccs/loadpolicy
/usr/lib/ccs/editpolicy
/usr/lib/ccs/setlevel
/usr/lib/ccs/setprofile
/usr/lib/ccs/ld-watch
/usr/lib/ccs/ccs-queryd

*** /sys/kernel/security/tomoyo/exception_policy ***

This file is used to read and write system global settings. Each line 
has a directive and operand pair. Directives are listed below.

- initialize_domain:
To initialize domain transition when specific program is executed, 
use initialize_domain directive.
  * initialize_domain "program" from "domain"
  * initialize_domain "program" from "the last program part of domain"
  * initialize_domain "program"
If the part "from" and after is not given, the entry is applied to 
all domain. If the "domain" doesn't start with "<kernel>", the entry 
is applied to all domain whose domainname ends with "the last program 
part of domain".
This directive is intended to aggregate domain transitions for daemon 
program and program that are invoked by the kernel on demand, by 
transiting to different domain.

- keep_domain
To prevent domain transition when program is executed from specific 
domain, use keep_domain directive.
  * keep_domain "program" from "domain"
  * keep_domain "program" from "the last program part of domain"
  * keep_domain "domain"
  * keep_domain "the last program part of domain" 
If the part "from" and before is not given, this entry is applied to 
all program. If the "domain" doesn't start with "<kernel>", the entry 
is applied to all domain whose domainname ends with "the last program 
part of domain".
This directive is intended to reduce total number of domains and 
memory usage by suppressing unneeded domain transitions.
To declare domain keepers, use keep_domain directive followed by 
domain definition.
Any process that belongs to any domain declared with this directive, 
the process stays at the same domain unless any program registered 
with initialize_domain directive is executed.

In order to control domain transition in detail, you can use 
no_keep_domain/no_initialize_domain keywrods.

- alias: 
To allow executing programs using the name of symbolic links, use 
alias keyword followed by dereferenced pathname and reference 
pathname. For example, /sbin/pidof is a symbolic link to 
/sbin/killall5 . In normal case, if /sbin/pidof is executed, the 
domain is defined as if /sbin/killall5 is executed. By specifying 
"alias /sbin/killall5 /sbin/pidof", you can run /sbin/pidof in the 
domain for /sbin/pidof .
(Example)
alias /sbin/killall5 /sbin/pidof

- allow_read:
To grant unconditionally readable permissions, use allow_read keyword 
followed by canonicalized file. This keyword is intended to reduce 
size of domain policy by granting read access to library files such 
as GLIBC and locale files. Exception is, if ignore_global_allow_read 
keyword is given to a domain, entries specified by this keyword are 
ignored.
(Example)
allow_read /lib/libc-2.5.so

- file_pattern:
To declare pathname pattern, use file_pattern keyword followed by 
pathname pattern. The pathname pattern must be a canonicalized 
Pathname. This keyword is not applicable to neither granting execute 
permissions nor domain definitions.
For example, canonicalized pathname that contains a process ID 
(i.e. /proc/PID/ files) needs to be grouped in order to make access 
control work well.
(Example)
file_pattern /proc/\$/cmdline

- path_group
To declare pathname group, use path_group keyword followed by name of 
the group and pathname pattern. For example, if you want to group all 
files under home directory, you can define
   path_group HOME-DIR-FILE /home/\*/\*
   path_group HOME-DIR-FILE /home/\*/\*/\*
   path_group HOME-DIR-FILE /home/\*/\*/\*/\*
in the exception policy and use like
   allow_read @HOME-DIR-FILE
to grant file access permission.

- deny_rewrite:
To deny overwriting already written contents of file (such as log 
files) by default, use deny_rewrite keyword followed by pathname 
pattern. Files whose pathname match the patterns are not permitted to 
open for writing without append mode or truncate unless the pathnames 
are explicitly granted using allow_rewrite keyword in domain policy.
(Example)
deny_rewrite /var/log/\*

- aggregator
To deal multiple programs as a single program, use aggregator keyword 
followed by name of original program and aggregated program. This 
keyword is intended to aggregate similar programs.
For example, /usr/bin/tac and /bin/cat are similar. By specifying 
"aggregator /usr/bin/tac /bin/cat", you can run /usr/bin/tac in the 
domain for /bin/cat .
For example, /usr/sbin/logrotate for Fedora Core 3 generates programs 
like /tmp/logrotate.\?\?\?\?\?\? and run them, but TOMOYO Linux 
doesn't allow using patterns for granting execute permission and 
defining domains. By specifying 
"aggregator /tmp/logrotate.\?\?\?\?\?\? /tmp/logrotate.tmp", you can 
run /tmp/logrotate.\?\?\?\?\?\? as if /tmp/logrotate.tmp is running.

*** /sys/kernel/security/tomoyo/domain_policy ***

This file contains definition of all domains and permissions that are 
granted to each domain.

Lines from the next line to a domain definition ( any lines starting 
with "<kernel>") to the previous line to the next domain definitions 
are interpreted as access permissions for that domain.

*** /sys/kernel/security/tomoyo/meminfo ***

This file is to show the total RAM used to keep policy in the kernel 
by TOMOYO Linux in bytes.
(Example)
[root@tomoyo]# cat /sys/kernel/security/tomoyo/meminfo
Shared:       61440
Private:      69632
Dynamic:        768
Total:       131840

You can set memory quota by writing to this file.
(Example)
[root@tomoyo]# echo Shared: 2097152 > /sys/kernel/security/tomoyo/meminfo
[root@tomoyo]# echo Private: 2097152 > /sys/kernel/security/tomoyo/meminfo

*** /sys/kernel/security/tomoyo/self_domain ***

This file is to show the name of domain the caller process belongs to.
(Example)
[root@etch]# cat /sys/kernel/security/tomoyo/self_domain
<kernel> /usr/sbin/sshd /bin/zsh /bin/cat

*** /sys/kernel/security/tomoyo/version ***

This file is used for getting TOMOYO Linux's version.
(Example)
[root@etch]# cat /sys/kernel/security/tomoyo/version
2.2.0-pre

*** /sys/kernel/security/tomoyo/.domain_status ***

This is a view (of a DBMS) that contains only profile number and 
domainnames of domain so that "ccs-setprofile" command can do 
line-oriented processing easily.

*** /sys/kernel/security/tomoyo/.process_status ***

This file is used by "ccs-ccstree" command to show "list of processes 
currently running" and "domains which each process belongs to" and 
"profile number which the domain is currently assigned" like "pstree" 
command. This file is writable by programs that aren't registered as 
policy manager.

Regards,


