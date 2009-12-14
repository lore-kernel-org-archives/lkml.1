Return-Path: <linux-kernel-owner+w=401wt.eu-S932527AbZLNUva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbZLNUva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbZLNUv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:51:29 -0500
Received: from outbound-mail-117.bluehost.com ([69.89.22.17]:33174 "HELO
	outbound-mail-117.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757543AbZLNUv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:51:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KdmKmcXsGnHFMVqY5h6gJq9F4AgZHOCIrKnapQ4dxe76WNzuAsw+ZF5SrwEOJdQZlz7aiss3GwFM5wU2h6onZ9Dm3Evqvrk1suYHpgrzMHEs1at37cMes6HFngvDEj4X;
Date: Mon, 14 Dec 2009 12:50:24 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel@ffwll.ch>,
       Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com, eric@anholt.net,
       Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes
 when ..."
Message-ID: <20091214125024.77601d7e@jbarnes-piketon>
In-Reply-To: <200912142038.09254.arnd@arndb.de>
References: <200912071830.14697.arnd@arndb.de>
	<1260741245.3123.0.camel@t60prh>
	<20091214102015.2f43f5b4@jbarnes-piketon>
	<200912142038.09254.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 20:38:09 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 14 December 2009 18:20:15 Jesse Barnes wrote:
> > You can disable most of that code by loading i915 with
> > 'powersave=0'. If that patch really is at fault the powersave=0
> > should work around the issue as well.
> 
> Ok, I'll try that and let you know. Running the kernel before your
> patch has not crashed yet after two days of uptime. Now running
> with your patch but nothing else. When that crashes, I'll try
> the latest mainline with powersave=0.

Ok great.

> > It's been implicated in another issue (some display flicker and
> > underruns) so I'm pretty sure there's something wrong with it in
> > some configurations at least...
> 
> I haven't seen that yet. FWIW, the device in question is

[snip 4 series pci info]
 
> Let me know if you have a patch you want me to test.

This patch removes the suspect portion of the dynamic clock control
code.  Hopefully it'll be as stable as powersave=0 in your config
(assuming powersave=0 works :).

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_d
index 279dc96..b8730de 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3825,8 +3825,6 @@ void intel_decrease_renderclock(struct drm_device *dev)
                /* Down to minimum... */
                gcfgc &= ~GM45_GC_RENDER_CLOCK_MASK;
                gcfgc |= GM45_GC_RENDER_CLOCK_266_MHZ;
-
-               pci_write_config_word(dev->pdev, GCFGC, gcfgc);
        } else if (IS_I965G(dev)) {
                u16 gcfgc;
 
