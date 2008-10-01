Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYJASWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYJASWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbYJASWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:22:33 -0400
Received: from smtp103.prem.mail.sp1.yahoo.com ([98.136.44.58]:24616 "HELO
	smtp103.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753604AbYJASWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:22:32 -0400
X-YMail-OSG: J5wJItAVM1k.Qxg15F4lrucmZepZg15QYfC9.jczXcP0ceyhNHc.T7QXBhepRedph9D0lK6Nhiaw.SHoz5qU84j19Kza2MH34px2Apujv8.3hYRsSr791uPx09.A2nymVSHY2k_gxtkxPIjU.Civ838x1jQl1aXbuE3BahW5W.DFFp8bSA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48E3BFDE.7010300@schaufler-ca.com>
Date: Wed, 01 Oct 2008 11:22:22 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Tilman Baumann <tilman.baumann@collax.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com> <48E3957A.7040201@schaufler-ca.com> <48E3AB97.8020305@collax.com>
In-Reply-To: <48E3AB97.8020305@collax.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Baumann wrote:
> Casey Schaufler wrote:
>> Tilman Baumann wrote:
>>> Casey Schaufler wrote:
>>>> Smack will eventually bite you if you're not careful, but users of
>>>> MAC systems wouldn't be surprised by that.
>>> Speaking of the devil...
>>> This is exactly what happened to me right now. I have problems with 
>>> _some_ https connects. The problem lies somewhere in openssl.
>>> I did not yet find any clue with strace.
>>> Is there some straight forward way to audit/debug LSM interventions?
>>
>> strace is probably your best bet, as it will tell you what syscalls
>> fail. Your current situation is most likely a case where your program
>> running with a label "Foo" is trying to communicate with a service on
>> a machine that doesn't talk CIPSO and hence Smack is treating all
>> packets to and from that host with the ambient (%cat /smack/ambient)
>> label, which is "_" unless you've changed it.
>
> Yea, I just found that out.
> I did not expect smack to add netlabels by default. I thought I would 
> need to configure something before it will start adding netlabels 'on 
> the wire'.

It's pretty important to do it the way it is, because if a "Foo" process
can talk to port/host and a "Bar" process can talk to the same you can
pretty well assume that you have an information channel. I'm starting
to think about how I might go about allowing you to do it anyway.

> In my case 'security' is something that should only concern the local 
> machine.

Unfortunately, any time you talk off the machine you have to consider that
the other machine(s) may not be very careful about information flows.

> Unfortunately I never bothered to test this before. :-/
>
> If I set /smack/nltype to 'unlabeled' I have effectively shut off the 
> network.
> I guess I'm missing some essential point here.
> Sorry to bother you with such trivialities.

Not to worry. The essential point is that with MAC you can't just lock
the doors, you have to lock the windows as well. What I mean by that is
that traditional access controls apply to files, but not network
communications. Network communications became popular in part because
they were allowed to leave any restrictions up to the applications
and their protocols. MAC requirements are pickier than that. The good
news is that with a scheme like CIPSO you can easily enforce the
policy. The bad news is that network services in general assume that
there is no policy being enforced on them.

>
> btw. I find it very hard to find informations on the various files in 
> /smack/ and it's respective intention and formating rules. 
> security/smack/smackfs.c helps a bit.
If you pull down the smack-util-0.1 package from http://schaufler-ca.com
you will find programs that will do that formatting for you.
>
> This is my current setup:
> /smack/ambient (default)
> /smack/load = _ foo rwx
> Unlabeled process work fine.
> Labeled processes produce CIPSO labeled packets (which never get any 
> answer anywhere from the internet)
>
> If i set /smack/nltype to 'unlabled' i don't even get SYN packets out. 
> (operation not permitted)

That's probably a bug, but I think the "fix" is to disable the ability to
set the nltype to anything other than CIPSO at least for the time being.

