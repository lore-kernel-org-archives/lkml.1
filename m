Return-Path: <linux-kernel-owner+w=401wt.eu-S1758457AbZF2Jjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457AbZF2Jjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZF2Jji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:39:38 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35903 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbZF2Jjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:39:37 -0400
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: kmemleak reports firmware loader funnies in iwlwifi
References: <20090626171933.GA23170@redhat.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 29 Jun 2009 10:39:17 +0100
In-Reply-To: <20090626171933.GA23170@redhat.com> (Dave Jones's message of "Fri\, 26 Jun 2009 13\:19\:33 -0400")
Message-ID: <tnxy6rbv0oq.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Jun 2009 09:39:23.0987 (UTC) FILETIME=[7C8BF230:01C9F89D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> wrote:
> iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
> kmemleak: Freeing unknown object at 0xffffc90018070000
> Pid: 1034, comm: NetworkManager Not tainted 2.6.31-0.25.rc0.git22.fc12.x86_64
> #1
> Call Trace:
>  [<ffffffff81139f74>] delete_object+0x5b/0x13b
>  [<ffffffff8113b012>] kmemleak_free+0x5b/0xb5
>  [<ffffffff8111dc51>] vfree+0x40/0x68
>  [<ffffffff813485e6>] release_firmware+0x49/0x6c
>  [<ffffffffa021997c>] ? iwl_mac_start+0xc5c/0x106b [iwlagn]
>  [<ffffffffa0219adc>] iwl_mac_start+0xdbc/0x106b [iwlagn]
>  [<ffffffff8109df9b>] ? __module_text_address+0x25/0x85
>
>
> So it appears to be vfree'ing something that it had no knowledge of
> ever allocating.  afaict _request_firmware only vmallocs when it's
> using a firmware image built into the driver, which isn't the case
> here, so I'm not sure why we end up trying to vfree instead of kfree
> when we call release_firmware

It seems that firmware_loading_store uses vmap() to set fw->data and
it later calls vfree() on this (maybe as a short-cut to vunmap +
__free_page).

Kmemleak doesn't track vmap allocations but tracks vmalloc/vfree
calls. A solution here is to track vmap/vunmap calls (setting the
block size to 0 or adding extra checks to make sure it doesn't scan
I/O or user pages).

Another solution (my preferred one) is to annotate some of the few
places where vmap may be used with vfree. In this particular case:


diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index ddeb819..26fb808 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -179,6 +179,13 @@ static ssize_t firmware_loading_store(struct device *dev,
 				dev_err(dev, "%s: vmap() failed\n", __func__);
 				goto err;
 			}
+			/*
+			 * This block of memory is later freed using vfree.
+			 * Since kmemleak does not track vmap calls, just
+			 * inform it about this block but ignore it during
+			 * scanning.
+			 */
+			kmemleak_alloc(fw_priv->fw->data, 0, -1, GFP_KERNEL);
 			/* Pages will be freed by vfree() */
 			fw_priv->pages = NULL;
 			fw_priv->page_array_size = 0;


-- 
Catalin
