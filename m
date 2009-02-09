Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZBINqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZBINqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbZBINqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:46:16 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:45814 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756032AbZBINqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:46:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QjuFPkECzncd+FaynUefI7k2rNycIwSPqPsCy1WegjZuwQbNYk8lZsXFW8CVOdDVFJCRplJEwVZ0q7Vb/c1TBKqqArFvVtqma59CaNsBt9GdySapPjrVNsY0CxAwCgTNFnftGXOQvzrSx21JmAKPwovUxqA0YNbBIbI06zgtY3Y=  ;
X-YMail-OSG: ovqHlHgVM1lt6URAE2j8Z9mywj9BR6Njrwmt_SDjwacqKmDRz.01VcnKun.XJ059bNYcTnrlZwIimVrTzG3gGFZeZnzKK8PF7vXNyKQhZAbdf3KBSLKwhwCUGtHLDcfTfQEFJvx8r0w44bdUg8nf5a9m2bjZDEY4iMlYB22IdiI7PlHVsxd9bMYg8OARCZLrarhxP8udhTpoANzeYQjiPiJW.iS4JLC0HNBHZA0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Federico Cuello <fedux@lugmen.org.ar>
Subject: Re: sync-Regression in 2.6.28.2?
Date: Tue, 10 Feb 2009 00:45:42 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
References: <20090127093533.GB7037@charite.de> <200902051425.19552.nickpiggin@yahoo.com.au> <498AD368.2090000@lugmen.org.ar>
In-Reply-To: <498AD368.2090000@lugmen.org.ar>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902100045.44386.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 22:54:16 Federico Cuello wrote:
> Nick Piggin wrote:
> > On Thursday 05 February 2009 04:31:00 Federico Cuello wrote:
> >> Nick Piggin wrote:
> >>> [...]
> >>> Thanks, could you reply-to-all when replying to retain ccs please?
> >>>
> >>> Common theme is ext4, which uses no_nrwrite_index_update, and I
> >>> introduced a bug in there which could possibly cause ext4 to go into a
> >>> loop...
> >>>
> >>> Would it be possible if you can test the following patch?
> >>
> >> I'll test it as soon as I get home.
> >
> > Thanks.
> >
> >> Meanwhile, I think the new patch may be slightly wrong. If I understand
> >> correctly PageWriteback(page) is called before nr_to_write is tested for
> >> being > 0 and then decremented if true, but "done" is  not set to 1
> >> until the next iteration. So another call to PageWriteback(page) while
> >> take place and then "done" will be set to true (if wbc->sync_mode ==
> >> WB_SYNC_NONE).
> >>
> >> If nr_to_write == 1 at the beginning of the loop then two pages will be
> >> written.
> >>
> >> I think the test condition should something like:
> >>
> >> if (--nr_to_write <= 0 && wbc->sync_mode == WB_SYNC_NONE) {
> >>     done = 1;
> >>     break;
> >> }
> >
> > I think you're quite right. Good catch. We probably want to prevent
> > nr_to_write from going -ve, though.
> >
> > I think something like this
> >
> >   if (nr_to_write > 0)
> >     nr_to_write--;
> >   if (!nr_to_write && wbc->sync_mode == WB_SYNC_NONE) {
> >     ...
> >
> > Would you care to send a patch?
>
> Ok, after extensive testing I haven't been able to solve the problem.
>
> I'm posting below the patch I used. I tried 3 different patches with one
> successful test run with the one you sent me. I don't know if it was
> just a coincidence as I had no time to test it again.
>
> Now, with the patch below, it stalls with 50% IO-wait (dual core, one
> core at 100%). Perhaps the patch is part of the solution, I don't know.
>
> I also have the sysrq-W logs and I'm also posting them below.
>
> Thanks,
>
>
>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 08d2b96..9e2ae50 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -981,13 +981,23 @@ continue_unlock:
>                                 }
>                         }
>
> -                       if (wbc->sync_mode == WB_SYNC_NONE) {
> -                               wbc->nr_to_write--;
> -                               if (wbc->nr_to_write <= 0) {
> +                       if (nr_to_write > 0) {
> +                               nr_to_write--;
> +                               if (nr_to_write == 0 && wbc->sync_mode
> == WB_SYNC_NONE) {
> +                                       /*
> +                                        * We stop writing back only if
> we are not
> +                                        * doing integrity sync. In case
> of integrity
> +                                        * sync we have to keep going
> because someone
> +                                        * may be concurrently dirtying
> pages, and we
> +                                        * might have synced a lot of
> newly appeared
> +                                        * dirty pages, but have not
> synced all of the
> +                                        * old dirty pages.
> +                                        */
>                                         done = 1;
>                                         break;
>                                 }
>                         }
> +
>                         if (wbc->nonblocking && bdi_write_congested(bdi)) {
>                                 wbc->encountered_congestion = 1;
>                                 done = 1;

This patch seems good to me. If you would care to add a changelog and
Signed-off-by: line, then we could get it merged?

I am not too sure about this bug. I have reproduced a strange hang with
ext4 (which does include sys_sync and write_cache_pages traces), and
also turned up a lockdep report. Also, we haven't seen any reports of
this problem on other filesystems. So it could be an ext4 bug.

Your traces also have lots of tasks hung waiting for page lock. It is
possible that wakeups get lost, which is fixed by this commit in
mainline
777c6c5f1f6e757ae49ecca2ed72d6b1f523c007

Which might also be your bug.


Any chance you can test this patch (as well as the existing patches
you are using to fix write_cache_pages?).

Thanks,
Nick

