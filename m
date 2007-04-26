Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbXDZWnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbXDZWnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbXDZWnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:43:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35279 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755173AbXDZWnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:43:06 -0400
Date: Fri, 27 Apr 2007 00:42:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070426224256.GB21926@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> <1177573348.5025.224.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'd really suggest _just_ the "full image". Nothing else is probably ever 
> worth supporting. Your "snapshot to disk" wouldn't be _quite_ as simple as 
> "echo disk > /sys/power/state", but it should not necessarily be much 
> worse than
> 
> 	snapshot_kernel | gzip -9 > /dev/snapshot

Yep, we "freeze too much", so we can't just use the shell and pipe
it. Too bad.

  218 int write_image(char *resume_dev_name)
  219 {
  220 	static struct swap_map_handle handle;
  221 	struct swsusp_info *header;
  222 	unsigned long start;
  223 	int fd;
  224 	int error;
  225 
  226 	fd = open(resume_dev_name, O_RDWR | O_SYNC);
  227 	if (fd < 0) {
  228 		printf("suspend: Could not open resume device\n");
  229 		return error;
  230 	}
  231 	error = read(dev, buffer, PAGE_SIZE);
  232 	if (error < PAGE_SIZE)
  233 		return error < 0 ? error : -EFAULT;
  234 	header = (struct swsusp_info *)buffer;
  235 	if (!enough_swap(header->pages)) {
  236 		printf("suspend: Not enough free swap\n");
  237 		return -ENOSPC;
  238 	}
  239 	error = init_swap_writer(&handle, fd);
  240 	if (!error) {
  241 		start = handle.cur_swap;
  242 		error = swap_write_page(&handle, header);
  243 	}
  244 	if (!error)
  245 		error = save_image(&handle, header->pages - 1);
  246 	if (!error) {
  247 		flush_swap_writer(&handle);
  248 		printf( "S" );
  249 		error = mark_swap(fd, start);
  250 		printf( "|\n" );
  251 	}
  252 	fsync(fd);
  253 	close(fd);
  254 	return error;
  255 }

This is basically the loop above, made complex by the fact that we do
not want to have separate partition for snapshot; we just want to
reuse free space in swap partition.

I think you've just invented uswsusp.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
