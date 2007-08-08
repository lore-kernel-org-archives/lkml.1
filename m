Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbXHHOYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbXHHOYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759596AbXHHOY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:24:29 -0400
Received: from rtr.ca ([64.26.128.89]:1123 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935248AbXHHOY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:24:27 -0400
Message-ID: <46B9D219.6030509@rtr.ca>
Date: Wed, 08 Aug 2007 10:24:25 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Michael Sedkowski <sedmich@gmail.com>, trenn@suse.de,
       Robert Hancock <hancockr@shaw.ca>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no>	 <fa.mg6p0itaOQUo/t8deCaYpyqj6Nk@ifi.uio.no>	 <fa.RxWYL8z8KktgL8LGZ/cTB2nI1Yc@ifi.uio.no>	 <fa.AyyCtZ2yLjC5noHPHtmzn4ffhhE@ifi.uio.no>	 <fa.SuAjism+m0z0haqCRVjkc2S978o@ifi.uio.no>	 <fa.QgWcLG2hfRb92g4blN61qYfRjlQ@ifi.uio.no> <46B7AF53.1040307@shaw.ca>	 <46B8140E.3000509@gmail.com>  <1186497925.8780.78.camel@queen.suse.de> <1186514618.5622.9.camel@nx6310> <46B9307D.3000105@gmail.com> <46B9CE79.5030307@rtr.ca> <46B9CFB3.6020402@gmail.com>
In-Reply-To: <46B9CFB3.6020402@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Mark Lord wrote:
>> > Tejun Heo wrote:
>>> >> Michael Sedkowski wrote:
>>>> >>> Dnia 07-08-2007, Wt o godzinie 03:43 +0900, Tejun Heo napisał(a):
>>>>> >>>> Does emergency unload count increase
>>>>> >>>> after each power down? 
>>>> >>> I think I got it.
>>>> >>> Using smartctl I've done a test and shut down, then repeted the test.
>>>> >>> The only values that where diffrent are temperatures and
>>>> >>> Hardware_ECC_Recovered which rised by 6 points.
>>>> >>> However I have no idea which of those is the "emergency count"...
>>>> >>> Full results in attachment.
>>>> >>>
>>>> >>> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age  
>>>> >>> Always       -       388
>>> >>
>>> >> I think this is the one.  You can test it by forcefully powering off the
>>> >> machine (press power button for several secs or disconnect AC and
>>> >> battery) and see whether the count increases.
>> > 
>> > FWIW, Tejun, with 2.6.22, my new Seagate 160GB SATA drive (notebook)
>> > increments the "Power-Off_Retract_Count" on each suspend-to-RAM operation.
>> > It does not do any double spin-up/spin-down things though.
>> > 
>> > What a mess.
> 
> Hmmm.. It shouldn't.  libata now issues STANDBYNOW prior to entering
> STR.  Can you instrument code a bit and see whether it actually gets issued?

Heh.. I haven't instrumented it yet, but I did discover a bit more about it:

The Power-Off_Retract_Count incrmenents *only* when there's data in the
on-drive write-cache.  So if I haven't written anything significantly large
before suspending, then it often does NOT increment the retract counter.

But if I copy a couple of multi-MB files around and then suspend (to RAM),
the retract count gets incremented.

So I've now just stuck "hdparm -F /dev/sda" into my suspend script,
and that cures the problem completely for me.  "-F" does a FLUSH_CACHE,
and requires a recent copy of hdparm.

Perhaps libata should also do a FLUSH_CACHE before any STANDBYNOW command,
prior to entering STR, which is what my script is currently now doing..

I'll instrument libata and see what the current sequence is.
