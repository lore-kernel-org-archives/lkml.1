Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbZGXKs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbZGXKs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZGXKsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:48:55 -0400
Received: from smtp.nokia.com ([192.100.105.134]:29001 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZGXKsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:48:55 -0400
Message-ID: <4A6991A5.4020105@nokia.com>
Date: Fri, 24 Jul 2009 13:49:09 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "Bityutskiy Artem (Nokia-M/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: ubifs: error unwinding trouble
References: <20090724103038.GN19257@buzzloop.caiaq.de>
In-Reply-To: <20090724103038.GN19257@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2009 10:48:34.0732 (UTC) FILETIME=[4AE91EC0:01CA0C4C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> On a recent git kernel, the error unwinding for UBIFS seems to have some
> problem, most probably a double-free or something similar.
> 
> When UBI is pointed to the right mtd partition (using command line
> arguments) , everything is fine. But when it's (accidentionally) set to
> some very small mtd, the attach process fails. Which wouldn't be a bad
> thing by itself, but it somehow messes up the slub/slab allocators then
> which causes very strange memory corruption effects - see the backtrace
> below.
> 
> The Ooops itself is unreleated to UBI, but it does not occur when UBI
> succeeds in attaching the volume.
> 
> Any idea? I searched for awhile but couldn't see anything obvious.

Looks like a double free of the eba_tbl

This might help:

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 0f2034c..e4d9ef0 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -1254,6 +1254,7 @@ out_free:
                if (!ubi->volumes[i])
                        continue;
                kfree(ubi->volumes[i]->eba_tbl);
+               ubi->volumes[i]->eba_tbl = NULL;
        }
        return err;
 }

