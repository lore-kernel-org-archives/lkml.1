Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbYDVCrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbYDVCrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 22:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbYDVCq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 22:46:56 -0400
Received: from smtp120.sbc.mail.re3.yahoo.com ([66.196.96.93]:29432 "HELO
	smtp120.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758228AbYDVCqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 22:46:55 -0400
X-YMail-OSG: P0qeMW4VM1mo_2zd8inZaSpgFwRD9MfZG48e1wThEj3eRUjSKNIZbrWEoMIP0hmXDfW9xRs7xJk8pfs08LPm8ITJdVi__RKTpZIAg9s8gOqzcTCBXIp2hy3CM3ymcnumhdMPjTEZpaDwx218MdnSHw--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 21 Apr 2008 21:42:59 -0500
From: serge@hallyn.com
To: David <david@unsolicited.net>
Cc: serge@hallyn.com, casey@schaufler-ca.com, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morgan <morgan@kernel.org>
Subject: Re: 2.6.25 Kernel - Problems with capabilities
Message-ID: <20080422024259.GA27223@vino.hallyn.com>
References: <46016.36939.qm@web36608.mail.mud.yahoo.com> <480B7D72.7020503@unsolicited.net> <20080421000055.GA17510@vino.hallyn.com> <20080421080101.htzh4s03snescog4@unsolicited.net> <20080421183451.GA22071@vino.hallyn.com> <480CE167.8090907@unsolicited.net> <20080421190143.GA23365@vino.hallyn.com> <480CF8DB.9010405@unsolicited.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480CF8DB.9010405@unsolicited.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David (david@unsolicited.net):
> serge@hallyn.com wrote:
>> Quoting David (david@unsolicited.net):
>>   
>>> serge@hallyn.com wrote:
>>>     
>>>>> /lib/libcap.so.1 -> libcap.so.1.92
>>>>>
>>>>> I guess that's 1.92 (should be the version shipped with SuSE 9.1).
>>>>>             
>>>> Ok, thanks, then it's definately not what I was thinking.
>>>>
>>>> (Will wait to check out your strace)
>>>>         
>>> strace attached.
>>>
>>> Cheers
>>> David
>>>
>>>     
>>
>> ...
>>   
>>> capget(0x20071026, 0, {, , })           = -1 EINVAL (Invalid argument)
>>>     
>>
>> This is odd.  libcap-1.x should be passing in 0x19980330.
>>
>> Next, given the -EINVAL return value ntpd should be seeing a NULL result
>> from cap_get_proc() and exiting right there.
>>
>> What version of ntpd is this?  (I must be looking at a wrong value, but
>> even so the fact that cap_get_proc()->capget() is using 0x20071026 for
>> version doesn't make sense)
>>
>>   
>>> capset(0, 0, {CAP_NET_BIND_SERVICE|CAP_SYS_TIME, 
>>> CAP_NET_BIND_SERVICE|CAP_SYS_TIME, CAP_NET_BIND_SERVICE|CAP_SYS_TIME}) = 
>>> -1 EINVAL (Invalid argument)
>>> time(NULL)                              = 1208803493
>>> write(5, "21 Apr 19:44:53 ntpd[6118]: cap_"..., 92) = 92
>>> munmap(0x40022000, 4096)                = 0
>>> exit_group(-1)                          = ?
>>> Process 6118 detached
>>>     
>>
>>   
> Oh dear .. more investigation... here's the source from libcap-1.92. 
> capget() is being called with null arguments, which I guess returns with 
> the latest version in ch.version ?
>
> The switch then fails and the set gets called with version = 0 ??
>
> Cheers
> David
>
> void _libcap_establish_api(void)
> {
>    struct __user_cap_header_struct ch;
>    struct __user_cap_data_struct cs;
>
>    if (_libcap_kernel_version) {
>        _cap_debug("already identified kernal api 0x%.8x",
>                   _libcap_kernel_version);
>        return;
>    }
>
>    memset(&ch, 0, sizeof(ch));
>    memset(&cs, 0, sizeof(cs));
>
>    (void) capget(&ch, &cs);
>
>    switch (ch.version) {
>
>    case 0x19980330:
>        _libcap_kernel_version = 0x19980330;
>        _libcap_kernel_features = CAP_FEATURE_PROC;
>        break;
>
>    case 0x19990414:
>        _libcap_kernel_version = 0x19990414;
>        _libcap_kernel_features = CAP_FEATURE_PROC|CAP_FEATURE_FILE;
>        break;
>
>    default:
>        _libcap_kernel_version = 0x00000000;
>        _libcap_kernel_features = 0x00000000;
>    }
>
>    _cap_debug("version: %x, features: %x\n",
>               _libcap_kernel_version, _libcap_kernel_features);
> }

Interesting.  The version I was looking at (1.10) has nothing like this.

I don't know what shipped with recent RedHat and Fedora distros, but I
guess based on this we can in fact expect more failures from at least
SuSe distros.

We can't reasonably have newer kernels reply to a query with an older
libcap version, so I don't know what to do here.  Andrew, do you have
any ideas?

thanks,
-serge
