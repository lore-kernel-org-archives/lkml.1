Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbZCXHkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbZCXHkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZCXHkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:40:09 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:38029 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbZCXHkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=yAk/zrT36UXmnoT98/JpuJ/2OiFH32np1/BNWjnCkZ2zUiUKuaE1intDWNyXQpaD7P
         aGBnBI3TPpcskF0Fq2Ymgb5KGtAAz+jFUKif8gKUXhj3JQhPo+b1GaKlvLD7y6w8A36j
         EC1ZPPITD7sWmH0RPmVuF5TTb23ffZt7Nw/dw=
Subject: fastboot: unpacking initramfs faster
From: Andreas Robinson <andr345@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 24 Mar 2009 08:39:08 +0100
Message-Id: <1237880348.7725.17.camel@andreas-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here's a quick update on what can be done to make initramfs unpacking
faster that I suggested a few weeks ago. There results are mixed.


The bad:

I tried running the initramfs unpacking asynchronously (and earlier) but
ran into a curious problem: The parent thread stalled until
decompression was done. I don't know why - I made sure that the two
threads ran on different cores. Perhaps the parent was cache starved.

I then looked at multithreaded decompression and found that neither gzip
files nor deflate streams provide enough information (eg block lengths)
to let you share the decompression among threads.

It can be done of course, but obviously not without modifying file
formats and userspace tools. 

(Thoughts of snowballs and hell presented themselves at this point.)


The good:

LZO compression is roughly twice as fast as gunzip while files are only
about 7% bigger. The file format is multiprocessing friendly and the
decompressor is already in the mainline kernel.

I estimate that single-threaded LZO would cut the unpacking time almost
in half even on a low-end PC with a slow drive, like the Eee 901.

Finally, someone already wrote support for bzip2 and lzma compressed
initramfs. It's in the -tip tree. Adding LZO to that list should be
straightforward so that's where I'm going next.

Cheers,
Andreas


