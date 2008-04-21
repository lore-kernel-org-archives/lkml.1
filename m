Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbYDUUaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbYDUUaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYDUU37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:29:59 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:44971 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYDUU36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:29:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
	b=oeNEtSRvU8Jb0GD3gsgdObHOUHTEqJbQIxEbfJlIliRuytDfr/wz/w0AdrS1oG2NE499jk1OayhK5xfLf4k9+SAW8r6zepycGqdcm7W2Pydk4XqRUpG/ZQmvi9gMzPNgyBqKyjUPiVvE4gk2wJ8zpIuQ0q/SxZzQ9y3i1YqRYoY=;
Message-ID: <480CF8DB.9010405@unsolicited.net>
Date: Mon, 21 Apr 2008 21:28:11 +0100
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: serge@hallyn.com
CC: casey@schaufler-ca.com, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morgan <morgan@kernel.org>
Subject: Re: 2.6.25 Kernel - Problems with capabilities
References: <46016.36939.qm@web36608.mail.mud.yahoo.com> <480B7D72.7020503@unsolicited.net> <20080421000055.GA17510@vino.hallyn.com> <20080421080101.htzh4s03snescog4@unsolicited.net> <20080421183451.GA22071@vino.hallyn.com> <480CE167.8090907@unsolicited.net> <20080421190143.GA23365@vino.hallyn.com>
In-Reply-To: <20080421190143.GA23365@vino.hallyn.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serge@hallyn.com wrote:
> Quoting David (david@unsolicited.net):
>   
>> serge@hallyn.com wrote:
>>     
>>>> /lib/libcap.so.1 -> libcap.so.1.92
>>>>
>>>> I guess that's 1.92 (should be the version shipped with SuSE 9.1).
>>>>     
>>>>         
>>> Ok, thanks, then it's definately not what I was thinking.
>>>
>>> (Will wait to check out your strace)
>>>   
>>>       
>> strace attached.
>>
>> Cheers
>> David
>>
>>     
>
> ...
>   
>> capget(0x20071026, 0, {, , })           = -1 EINVAL (Invalid argument)
>>     
>
> This is odd.  libcap-1.x should be passing in 0x19980330.
>
> Next, given the -EINVAL return value ntpd should be seeing a NULL result
> from cap_get_proc() and exiting right there.
>
> What version of ntpd is this?  (I must be looking at a wrong value, but
> even so the fact that cap_get_proc()->capget() is using 0x20071026 for
> version doesn't make sense)
>
>   
>> capset(0, 0, {CAP_NET_BIND_SERVICE|CAP_SYS_TIME, CAP_NET_BIND_SERVICE|CAP_SYS_TIME, CAP_NET_BIND_SERVICE|CAP_SYS_TIME}) = -1 EINVAL (Invalid argument)
>> time(NULL)                              = 1208803493
>> write(5, "21 Apr 19:44:53 ntpd[6118]: cap_"..., 92) = 92
>> munmap(0x40022000, 4096)                = 0
>> exit_group(-1)                          = ?
>> Process 6118 detached
>>     
>
>   
Oh dear .. more investigation... here's the source from libcap-1.92. 
capget() is being called with null arguments, which I guess returns with 
the latest version in ch.version ?

The switch then fails and the set gets called with version = 0 ??

Cheers
David

void _libcap_establish_api(void)
{
    struct __user_cap_header_struct ch;
    struct __user_cap_data_struct cs;

    if (_libcap_kernel_version) {
        _cap_debug("already identified kernal api 0x%.8x",
                   _libcap_kernel_version);
        return;
    }

    memset(&ch, 0, sizeof(ch));
    memset(&cs, 0, sizeof(cs));

    (void) capget(&ch, &cs);

    switch (ch.version) {

    case 0x19980330:
        _libcap_kernel_version = 0x19980330;
        _libcap_kernel_features = CAP_FEATURE_PROC;
        break;

    case 0x19990414:
        _libcap_kernel_version = 0x19990414;
        _libcap_kernel_features = CAP_FEATURE_PROC|CAP_FEATURE_FILE;
        break;

    default:
        _libcap_kernel_version = 0x00000000;
        _libcap_kernel_features = 0x00000000;
    }

    _cap_debug("version: %x, features: %x\n",
               _libcap_kernel_version, _libcap_kernel_features);
}


> thanks,
> -serge
>   

