Return-Path: <linux-kernel-owner+w=401wt.eu-S1765472AbXJSGSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765472AbXJSGSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 02:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXJSGSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 02:18:03 -0400
Received: from main.gmane.org ([80.91.229.2]:60733 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbXJSGSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 02:18:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Shreyansh Jain <shreyansh.jain@gmail.com>
Subject: Query about Bio submission / Direct IO 
Date: Fri, 19 Oct 2007 06:17:42 +0000 (UTC)
Message-ID: <loom.20071019T055230-553@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 192.8.220.10 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.7) Gecko/20070914 Firefox/2.0.0.7)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List,

I have tried this on kernelnewbies
<http://article.gmane.org/gmane.linux.kernel.kernelnewbies/23166> but it seems 
I am not good at explaining well. trying here again.

Question:
Is there a limitation (some kind of caveat) when direct IO pages are added to 
a bio (multiple pages per bio) and if the total length or offset of some of 
the vectors is not aligned (PAGE_SIZE or sector size)?

My scenario:
1. I have a filesystem in which I create bio for submission to a SCSI disk 
   connected in a SAN via a FC switch. 
2. This is a direct IO request where in multiple pages are being added in a bio
   (bio_map_user). Also, as the user buffer I get is unaligned, I am changing
    bio's first vector offset (as well as len, bi_size accordingly).

What I observe is:

1. IO is performed perfectly (as expected) in case there are no SCSI failure.
   end_bio gets called as expected and the user app is happy.
2. In case I  disconnect the SCSI device from switch, my end_bio function 
   keeps on getting sub-completion bio (bi_size > 0 and uptodate cleared,
   error set to -5).
3. For capturing and ignoring sub-completion returns from block layer, 
   using other kernel end_bio implementation as example I had a code like

    if(bio->bi_size > 0)
       return 1;

   as the starting lines of the end_bio routine. Thus, my user space goes off 
   to disk sleep and kernel log keeps on spweing messages like 

...
Oct 17 21:56:07 mgs02 kernel: end_request: I/O error, dev sdl, sector 33639
Oct 17 21:56:07 mgs02 kernel: sd 2:0:0:8: SCSI error: return code = 0x10000
Oct 17 21:56:07 mgs02 kernel: end_request: I/O error, dev sdl, sector 33639
Oct 17 21:56:07 mgs02 kernel: sd 2:0:0:8: SCSI error: return code = 0x10000
Oct 17 21:56:07 mgs02 kernel: end_request: I/O error, dev sdl, sector 33639
...

till i connect the switch back - even if that is one hour after disconnecting it.

Best part - it works amazingly well in case I keep the offset of the first page
aligned (somehow, at expense of corrupted data copy) - failure of SCSI disk
(end_bio returns, bi_size=0, my code captures error) or no failure.

I have tried this on 2.6.5 and 2.6.16.27 (I agree they are old, but that is 
what I have to work  on :( ). It is a qlogic SCSI HBA. I have created the bio
 just like other kernel subsystems do.

Only thing I am not sure is whether there is something special that needs to 
be done in case of direct IO which I am missing.

biodoc.txt states that:
"Note: Right now the only user of bios with more than one page is ll_rw_kio,
 which in turn means that only raw I/O uses it (direct i/o may not work right
 now)."

Any idea why it doesn't work (though I am expecting that this doc is 2.6
starting era and things might have changed a lot now).

Any help would be highly appreciated. Apologies if my channel of approach is
wrong and if this post is huge (couldn't keep it shorter than this).

Shreyansh


[PS: Is this situation something to do with request flags REQ_PC /
REQ_BLOCK_PC?? While searching code, I found these somewhere connected to 
direct IO (bio_add_pc_page) and could find more about them]

