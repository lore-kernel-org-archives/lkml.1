Return-Path: <linux-kernel-owner+w=401wt.eu-S1751518AbZH1Nqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbZH1Nqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 09:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbZH1Nqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 09:46:53 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:59095 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZH1Nqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 09:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tChTD2YqSIsR3tE+UedE2u0aGJqomGkQpbFCCzc5IMzQNtdA9jPq0IkS14JVqxzUBR
         bAeIrVDdhPi/fahauoM4Ir3mZdDx8a7BoDRHlGI55I3oMruHnmEfgCHNwVjMfoa0cPgS
         6SxHqJ0UOo3/XEnvRtzlq/g++BtshuPIsJ0PI=
MIME-Version: 1.0
In-Reply-To: <20090828125559.GD5054@csn.ul.ie>
References: <1251449067-3109-1-git-send-email-mel@csn.ul.ie>
	 <1251449067-3109-2-git-send-email-mel@csn.ul.ie>
	 <20090828205241.fc8dfa51.minchan.kim@barrios-desktop>
	 <28c262360908280500tb47685btc9f36ca81605d55@mail.gmail.com>
	 <20090828125559.GD5054@csn.ul.ie>
Date: Fri, 28 Aug 2009 22:46:54 +0900
Message-ID: <28c262360908280646s506db2ccsa3842ee33b241120@mail.gmail.com>
Subject: Re: [PATCH 1/2] page-allocator: Split per-cpu list into 
	one-list-per-migrate-type
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 9:56 PM, Mel Gorman<mel@csn.ul.ie> wrote:
> On Fri, Aug 28, 2009 at 09:00:25PM +0900, Minchan Kim wrote:
>> On Fri, Aug 28, 2009 at 8:52 PM, Minchan Kim<minchan.kim@gmail.com> wrote:
>> > Hi, Mel.
>> >
>> > On Fri, 28 Aug 2009 09:44:26 +0100
>> > Mel Gorman <mel@csn.ul.ie> wrote:
>> >
>> >> Currently the per-cpu page allocator searches the PCP list for pages of the
>> >> correct migrate-type to reduce the possibility of pages being inappropriate
>> >> placed from a fragmentation perspective. This search is potentially expensive
>> >> in a fast-path and undesirable. Splitting the per-cpu list into multiple
>> >> lists increases the size of a per-cpu structure and this was potentially
>> >> a major problem at the time the search was introduced. These problem has
>> >> been mitigated as now only the necessary number of structures is allocated
>> >> for the running system.
>> >>
>> >> This patch replaces a list search in the per-cpu allocator with one list per
>> >> migrate type. The potential snag with this approach is when bulk freeing
>> >> pages. We round-robin free pages based on migrate type which has little
>> >> bearing on the cache hotness of the page and potentially checks empty lists
>> >> repeatedly in the event the majority of PCP pages are of one type.
>> >>
>> >> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>> >> Acked-by: Nick Piggin <npiggin@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

>> >>   */
>> >> -static void free_pages_bulk(struct zone *zone, int count,
>> >> -                                     struct list_head *list, int order)
>> >> +static void free_pcppages_bulk(struct zone *zone, int count,
>> >> +                                     struct per_cpu_pages *pcp)
>> >>  {
>> >> +     int migratetype = 0;
>> >> +
>> >
>> > How about caching the last sucess migratetype
>> > with 'per_cpu_pages->last_alloc_type'?
>>                                          ^^^^
>>                                          free
>> > I think it could prevent a litte spinning empty list.
>>
>> Anyway, Ignore me.
>> I didn't see your next patch.
>>
>
> Nah, it's a reasonable suggestion. Patch 2 was one effort to reduce
> spinning but the comment was in patch 1 in case someone thought of
> something better. I tried what you suggested before but it didn't work
> out. For any sort of workload that varies the type of allocation (very
> frequent), it didn't reduce spinning significantly.

Thanks for good information.

> --
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
>



-- 
Kind regards,
Minchan Kim
