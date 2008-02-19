Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbYBSFsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbYBSFsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 00:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYBSFsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 00:48:23 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:58684 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbYBSFsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 00:48:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=R7TPzXit8DK5Gw7zbtiI4ZiER31crYXFRkLiOH/JCuSXpDOhIeDzhOej0+B3KoP4mcabPfHVYFmmXlndZ5lvuny17Vhfcm5ItjZxXBuiYZgwAIgbWpUw4kpxt5b+oj/cVTfGTz136Yo+NtlJ7XWpquZV+KWXbgqdVDAivvns9QU=
Message-ID: <9c9fda240802182148m6fd632pa7988530c5387245@mail.gmail.com>
Date: Tue, 19 Feb 2008 14:48:18 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: "Linux Filesystem Mailing List" <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Question about synchronous write on SSD
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 03ac9e67dce37dca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Don't you remember the topic "solid state drive access and context
switching" [1].
I want to measure it is really better performance on SSD?

To write it on ssd synchronously, I hacked the
'generic_make_request()' [2] and got following results.

# echo 3 > /proc/sys/vm/drop_caches
# tiotest -f 100 -R -d /dev/sdd1
Tiotest results for 4 concurrent io threads:
| Write         400 MBs |    4.7 s |  84.306 MB/s |   8.4 %  |  77.5 % |
| Read          400 MBs |    4.3 s |  92.945 MB/s |   7.2 %  |  53.5 % |
Tiotest latency results:
| Write        |        0.126 ms |      706.379 ms |  0.00000 |   0.00000 |
| Read         |        0.161 ms |      311.738 ms |  0.00000 |   0.00000 |

# echo 3 > /proc/sys/vm/drop_caches
# tiotest -f 1000 -R -d /dev/sdd1
Tiotest results for 4 concurrent io threads:
| Write        4000 MBs |   47.5 s |  84.124 MB/s |   7.0 %  |  83.6 % |
| Read         4000 MBs |   41.9 s |  95.530 MB/s |   7.8 %  |  55.6 % |
Tiotest latency results:
| Write        |        0.176 ms |      714.677 ms |  0.00000 |   0.00000 |
| Read         |        0.161 ms |      311.815 ms |  0.00000 |   0.00000 |

However it's same performance as before. It means the patch is meaningless.

Could you tell me is it the proper place to hack or others?

Thank you,
Kyungmin Park

p.s. Of cource I got the following message
WARNING: at block/blk-core.c:1351 generic_make_request+0x126/0x3d8()

1. http://lkml.org/lkml/2007/12/3/247
2. simple hack
diff --git a/block/blk-core.c b/block/blk-core.c
index e9754dc..7262720 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1345,6 +1345,14 @@ static inline void
__generic_make_request(struct bio *bio)
        if (bio_check_eod(bio, nr_sectors))
                goto end_io;

+       /* FIXME simple hack by kmpark */
+       if (MINOR(bio->bi_bdev->bd_dev) == 49 &&
+           MAJOR(bio->bi_bdev->bd_dev) == 8 && bio_data_dir(bio) == WRITE) {
+               WARN_ON_ONCE(1);
+               /* Write synchronous */
+               bio->bi_rw |= (1 << BIO_RW_SYNC);
+       }
+
        /*
         * Resolve the mapping until finished. (drivers are
         * still free to implement/resolve their own stacking
