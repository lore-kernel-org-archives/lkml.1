Return-Path: <linux-kernel-owner+w=401wt.eu-S1758422AbZGGO4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422AbZGGO4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbZGGO4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:56:13 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:36662 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425AbZGGO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=QdvyVhwV6R64RzRGAsp4isOeXNb2n0fJuaIMzgIA9FA0nkKPgJV4h2JAxYLl0LLZsM
         WWxUQvUtYfYvty2epNU8dZhCpehLdrNnqf4k2C4p4Q04vzJ60TU6ln5LaJfugPTsesPL
         pmaXtGL8ezftt7I7U55OEmKo3VVkW6V/zcXJo=
MIME-Version: 1.0
Date: Tue, 7 Jul 2009 20:26:11 +0530
Message-ID: <ed41fa890907070756k28a186b0n76e7ca2fb713d41f@mail.gmail.com>
Subject: SD card removal issues during data transfer
From: Vishwas Poghul <vishwaspoghul@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel MMC/SD developers,

I've been encountering some problems when I abruptly remove SD card
during data transfer (song playback ... more so when the amount of
transfer is huge)
The kernel gets stuck in mmc_request function in the loops below
if (!mq) {
                printk(KERN_ERR "MMC: killing requests for dead queue\n");
                while ((req = elv_next_request(q)) != NULL) {
                        do {

  ret = end_that_request_chunk(req, 0,
                                        req->current_nr_sectors << 9);
                        } while (ret);
                }
                return;
        }

elv_next_requests returns the current request which is then ended with
end_that_request_chunk, however the request is never dequeued. As a
result, every
iteration of the while returns the same request and this "while"
becomes an infinite loop with the same req being returned each time

I added a call to blkdev_dequeue_request(req); after the do_while but
within the while and with this change the while loop always ends but I
observed that the kernel MMC stack sometimes(infrequent though) does
not respond to mmc_detect_change upon the next card insertion.

I'm running an ARM9 port of 2.6.24.7 kernel on a custom board with a
custom SD host controller and always use 4 bit transfer mode

Any help/info or similar experiences would be of real help.

Thanks in advance

Vishwas
Engineer at BridgeCo
