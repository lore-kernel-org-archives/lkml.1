Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbZDQSB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbZDQSB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758875AbZDQSBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:01:48 -0400
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:37798 "HELO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757702AbZDQSBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:01:48 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] mm/page-writeback.c: fix sparse warnings
Date: Fri, 17 Apr 2009 14:01:20 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F9194@mi8nycmail19.Mi8.com>
In-Reply-To: <20090417052730.GA2505@cmpxchg.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mm/page-writeback.c: fix sparse warnings
Thread-Index: Acm/HUDGtByjUv3cTY+GFZ0eojNFTQAaFMkg
References: <BD79186B4FD85F4B8E60E381CAEE1909015F9049@mi8nycmail19.Mi8.com> <20090417052730.GA2505@cmpxchg.org>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Johannes Weiner" <hannes@cmpxchg.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Apr 2009 18:01:46.0188 (UTC) FILETIME=[928B10C0:01C9BF86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 16, 2009 10:28 PM, Johannes Weiner wrote:
> On Thu, Apr 16, 2009 at 09:26:35PM -0400, H Hartley Sweeten wrote:
>> Fix two sparse warnings in mm/page-writeback.c.
>
> You fixed code rather than warnings, right? ;)

Correct. I should have used a different subject...

>> get_dirty_limits() calls clip_bdi_dirty_limit() and
task_dirty_limit()
>> with variable pbdi_dirty as one of the arguments. This variable is
>> an unsigned long * but both functions expect it to be a long *. This
>> causes the following sparse warnings:
>> 
>>   warning: incorrect type in argument 3 (different signedness)
>>      expected long *pbdi_dirty
>>      got unsigned long *pbdi_dirty
>>   warning: incorrect type in argument 2 (different signedness)
>>      expected long *pdirty
>>      got unsigned long *pbdi_dirty
>> 
>> Fix the warnings by changing the long * to unsigned long * in both
>> functions.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> 
>> ---
>> 
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index 30351f0..e40b3e3 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -265,18 +265,20 @@ static void bdi_writeout_fraction(struct
>> backing_dev_info *bdi,
>>   * This avoids exceeding the total dirty_limit when the floating
>> averages
>>   * fluctuate too quickly.
>>   */
>> -static void
>> -clip_bdi_dirty_limit(struct backing_dev_info *bdi, long dirty, long
>> *pbdi_dirty)
>
> Your patches wrap, please fix your mail client to not do this.

Sorry about that. As far as I can tell, wrap occurs when my email
provider
bounces the message. I'm working on trying to get it resolved.

>> +static void clip_bdi_dirty_limit(struct backing_dev_info *bdi,
>> +		unsigned long dirty, unsigned long *pbdi_dirty)
>>  {
>> -	long avail_dirty;
>> +	unsigned long avail_dirty;
>> +	unsigned long nr_pages;
>>  
>> -	avail_dirty = dirty -
>> -		(global_page_state(NR_FILE_DIRTY) +
>> +	nr_pages = global_page_state(NR_FILE_DIRTY) +
>>  		 global_page_state(NR_WRITEBACK) +
>>  		 global_page_state(NR_UNSTABLE_NFS) +
>> -		 global_page_state(NR_WRITEBACK_TEMP));
>> +		 global_page_state(NR_WRITEBACK_TEMP);
>>  
>> -	if (avail_dirty < 0)
>> +	if (nr_pages < dirty)
>> +		avail_dirty = dirty - nr_pages;
>> +	else
>>  		avail_dirty = 0;
>
> No need for a new variable, especially if nr_pages really counts
> available dirty pages.
>
>	avail_dirty = global_page_state() + ...
>	if (avail_dirty < dirty)
>		avail_dirty = dirty - avail_dirty;
>	else
>		avail_dirty = 0;
>
> Hm?

True. Didn't think about that.

I will update the patch and resubmit. Unfortunately it will wrap again.
;-)

Regards,
Hartley
