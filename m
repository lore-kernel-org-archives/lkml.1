Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbZCXJWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbZCXJWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbZCXJWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:22:41 -0400
Received: from dgate20.fujitsu-siemens.com ([80.70.172.51]:22909 "EHLO
	dgate20.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753969AbZCXJWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:22:39 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:X-Enigmail-Version:Content-Type:
   Content-Transfer-Encoding;
  b=I59HFhjd5P56izrfBKSA9v7rEjW3fBGtJmT1VSS7eOKymMnVb5YCMBVZ
   1XUNuJgb+QLx5SQPMyG9XhymtR6LxVJGLmK+IqVopStWZf1s8QAj5/2L3
   DG23iSNJ4Keu4mA;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.38,411,1233529200"; 
   d="scan'208";a="57394463"
X-IronPort-AV: E=Sophos;i="4.38,411,1233529200"; 
   d="scan'208";a="50041307"
Message-ID: <49C8A65A.9030301@fujitsu-siemens.com>
Date: Tue, 24 Mar 2009 10:22:34 +0100
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH] limit CPU time spent in kipmid (PREVIOUS WAS BROKEN)
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org> <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org> <20090320174701.GA14823@kroah.com> <49C3E03E.10506@acm.org> <49C78BE0.9090107@fujitsu-siemens.com> <49C7F368.5040304@acm.org>
In-Reply-To: <49C7F368.5040304@acm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corey,

thanks a lot for your comments.

> I've done some experimenting with your patch and some more thinking.  
> (BTW, setting the permissions of kipmid_max_busy to 0644 as Greg 
> suggested makes changing the value for testing a lot easier :).
> 
> Results are not so good with the system I was working with.  

I expected things to differ between various systems.

> I have a 
> tool that measures latency of individual messages, averaging over a 
> number of messages.  It's part of the openipmi library, if you want to 
> grab it.

I will check it out.

> I'm also pretty sure I know what is going on in general.  You are using 
> ipmitool to fetch sensors with a short poll time and your management 
> controller does not implement a useful feature.

Some of the SDRs were useful temperature sensors. The SEL data were also 
useful data. I wanted to have a simple benchmark that produces a similar 
load to a real situation. I am grateful for a suggestion of a better tool.

> The reason that some systems doing this use a lot of CPU and other 
> systems do not has do with the management controller design.  Some 
> management controllers implement a UUID and a timestamp on the SDR data. 
> ipmitool will locally cache the data and if the UUID and timestamp are 
> the same it will not fetch the SDRs.  Just fetching the sensor values 
> will be very efficient, much like the Get MC ID command.   If this is 
> not implemented in the management controller, ipmitool will fetch all 
> the SDRs every time you run it, which is terribly inefficient.  I'm 
> guessing that's your situation.

In the benchmark case, this is what I intended to do (I wanted to 
measure the KCS driver performance and load, after all). In the real 
life situation, we aren't using ipmitool at all, we have our own server 
management daemon.

> I'm ok with the patch with the feature disabled by default.  I'd prefer 
> for it to be disabled by default because I prefer to reward vendors that 
> make our lives better and punish vendors that make our lives worse :).  
  on the user side.
I agree the current behavior is good as default.

> You should run it through checkpatch; there were one or two coding style 
> violations.

Weird, I ran it. Perhaps not the latest version. I will resend soon.

> I also have a few suggestions for solving this problem outside of this 
> patch:
> 
>    1. Get your vendor to implement UUIDs and timestamps.  This will make
>       things run more than an order of magnitude faster and more
>       efficient.  Even better than interrupts.
>    2. If that's not possible, don't use ipmitool.  Instead, write a
>       program with the openipmi library that stays up all the time (so
>       the SDR fetch is only done once at startup) and dumps the sensors
>       periodically.

This is what we are doing in real life. I need to check how much caching 
the user space tool does, though.

>    3. If that's not feasible, poll less often and use events to catch
>       critical changes.  Of course, this being IPMI, some vendors don't
>       properly implement events on their sensors, so that may not work.

You forgot to suggest "implement BT" :-) still the best thing to do IMO.

Best regards,
Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DEV 6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
