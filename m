Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbZFHQ3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbZFHQ3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZFHQ3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:29:25 -0400
Received: from mail-qy0-f195.google.com ([209.85.221.195]:37973 "EHLO
	mail-qy0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbZFHQ3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:29:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ehlPuFz5/GkWzBVUa7jPcOl5k9P4sg+aCEE67VemZDuVHzoiyPqc5EODLP+y1+p2XH
         vcYaRTxo1Pt7pNHA3clhZRyGcPtyVDq/fQaG3Ta61fPpcwtKny4fIs/hdCozbIaus4Dh
         NW7dsQwEoeZ94YOI2Us6y7i8/WOm2e6YaEoco=
MIME-Version: 1.0
In-Reply-To: <20090608091544.53a94235@nehalam>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.xm.Vb7KKB@chimera> <20090608091544.53a94235@nehalam>
Date: Mon, 8 Jun 2009 09:29:23 -0700
X-Google-Sender-Auth: 41bb024c702b9cdc
Message-ID: <e9c3a7c20906080929l1a4ec739t7585f6bba54bf684@mail.gmail.com>
Subject: Re: [Bug #13116] Can't boot with nosmp
From: Dan Williams <dan.j.williams@intel.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 8, 2009 at 9:15 AM, Stephen Hemminger<shemminger@vyatta.com> wrote:
> On Sun,  7 Jun 2009 11:52:49 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.29.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13116
>> Subject               : Can't boot with nosmp
>> Submitter     : Stephen Hemminger <shemminger@vyatta.com>
>> Date          : 2009-04-15 4:18 (54 days old)
>> References    : http://marc.info/?l=linux-kernel&m=123976917817920&w=4
>> Handled-By    : Dan Williams <dan.j.williams@intel.com>
>>
>>
>
> I suspect this bit of code in dmaengine is the culprit:
>
>        /* redistribute available channels */
>        n = 0;
>        for_each_dma_cap_mask(cap, dma_cap_mask_all)
>                for_each_online_cpu(cpu) {
>                        if (num_possible_cpus() > 1)
>                                chan = nth_chan(cap, n++);
>                        else
>                                chan = nth_chan(cap, -1);
>
> Why does num_possible_cpus() == 1 have to be a special case?

When there will only be one cpu the channel allocation policy changes from:
"isolate a channel per cpu"
...to:
"isolate a capability per channel".

For example, isolating per channel allows a memcpy to run concurrently
with an xor.
