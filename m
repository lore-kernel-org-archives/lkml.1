Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbXJVKxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbXJVKxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 06:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXJVKxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 06:53:14 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8516 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751514AbXJVKxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 06:53:14 -0400
Message-ID: <471C8114.7020702@panasas.com>
Date: Mon, 22 Oct 2007 12:53:08 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Shreyansh Jain <shreyansh.jain@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Query about Bio submission / Direct IO
References: <loom.20071019T055230-553@post.gmane.org>
In-Reply-To: <loom.20071019T055230-553@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2007 10:53:09.0511 (UTC) FILETIME=[BBE75170:01C81499]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19 2007 at 8:17 +0200, Shreyansh Jain <shreyansh.jain@gmail.com> wrote:
> Hi List,
> 
> I have tried this on kernelnewbies
> <http://article.gmane.org/gmane.linux.kernel.kernelnewbies/23166> but it seems 
> I am not good at explaining well. trying here again.
> 
> Question:
> Is there a limitation (some kind of caveat) when direct IO pages are added to 
> a bio (multiple pages per bio) and if the total length or offset of some of 
> the vectors is not aligned (PAGE_SIZE or sector size)?
> 
> My scenario:
> 1. I have a filesystem in which I create bio for submission to a SCSI disk 
>    connected in a SAN via a FC switch. 
> 2. This is a direct IO request where in multiple pages are being added in a bio
>    (bio_map_user). Also, as the user buffer I get is unaligned, I am changing
>     bio's first vector offset (as well as len, bi_size accordingly).
> 
> What I observe is:
> 
> 1. IO is performed perfectly (as expected) in case there are no SCSI failure.
>    end_bio gets called as expected and the user app is happy.
> 2. In case I  disconnect the SCSI device from switch, my end_bio function 
>    keeps on getting sub-completion bio (bi_size > 0 and uptodate cleared,
>    error set to -5).
> 3. For capturing and ignoring sub-completion returns from block layer, 
>    using other kernel end_bio implementation as example I had a code like
> 
>     if(bio->bi_size > 0)
>        return 1;
> 
>    as the starting lines of the end_bio routine. Thus, my user space goes off 
>    to disk sleep and kernel log keeps on spweing messages like 
> 
> ...
> Oct 17 21:56:07 mgs02 kernel: end_request: I/O error, dev sdl, sector 33639
> Oct 17 21:56:07 mgs02 kernel: sd 2:0:0:8: SCSI error: return code = 0x10000
> Oct 17 21:56:07 mgs02 kernel: end_request: I/O error, dev sdl, sector 33639
> Oct 17 21:56:07 mgs02 kernel: sd 2:0:0:8: SCSI error: return code = 0x10000
> Oct 17 21:56:07 mgs02 kernel: end_request: I/O error, dev sdl, sector 33639
> ...
> 
> till i connect the switch back - even if that is one hour after disconnecting it.
> 
> Best part - it works amazingly well in case I keep the offset of the first page
> aligned (somehow, at expense of corrupted data copy) - failure of SCSI disk
> (end_bio returns, bi_size=0, my code captures error) or no failure.
> 
> I have tried this on 2.6.5 and 2.6.16.27 (I agree they are old, but that is 
> what I have to work  on :( ). It is a qlogic SCSI HBA. I have created the bio
>  just like other kernel subsystems do.
> 
> Only thing I am not sure is whether there is something special that needs to 
> be done in case of direct IO which I am missing.
> 
> biodoc.txt states that:
> "Note: Right now the only user of bios with more than one page is ll_rw_kio,
>  which in turn means that only raw I/O uses it (direct i/o may not work right
>  now)."
> 
> Any idea why it doesn't work (though I am expecting that this doc is 2.6
> starting era and things might have changed a lot now).
> 
> Any help would be highly appreciated. Apologies if my channel of approach is
> wrong and if this post is huge (couldn't keep it shorter than this).
> 
> Shreyansh
> 
> 
> [PS: Is this situation something to do with request flags REQ_PC /
> REQ_BLOCK_PC?? While searching code, I found these somewhere connected to 
> direct IO (bio_add_pc_page) and could find more about them]
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

There was a related fix to a similar problem by Mike Christie, in resent
Kernels, If there is no chance for you working on newer kernels, than you
will have to back port it.

it is:
commit bd441deaf341c524b28fd72831ebf6fef88f1c41
Author: Mike Christie <michaelc@cs.wisc.edu>
Date:   Tue Mar 13 12:52:29 2007 -0500

    [SCSI] fix write buffer length in scsi_req_map_sg()

 
look it up the git trees on kernel.org

Boaz
