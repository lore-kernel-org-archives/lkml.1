Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYLNAlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYLNAlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 19:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYLNAlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 19:41:11 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51177 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYLNAlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 19:41:10 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4944561D.4010608@s5r6.in-berlin.de>
Date: Sun, 14 Dec 2008 01:41:01 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: Harvey Harrison <harvey.harrison@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ieee1934: dv1394 interrupt enabling/disabling broken
 on big-endian
References: <1229210489.11257.16.camel@brick>
In-Reply-To: <1229210489.11257.16.camel@brick>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For linux1394-devel to know:

Harvey Harrison wrote at LKML:
> After annotating the frame structs, this was left:
> drivers/ieee1394/dv1394.c:2113:23: warning: invalid assignment: |=
> drivers/ieee1394/dv1394.c:2113:23:    left side has type restricted __le32
> drivers/ieee1394/dv1394.c:2113:23:    right side has type int
> drivers/ieee1394/dv1394.c:2121:24: warning: invalid assignment: &=
> drivers/ieee1394/dv1394.c:2121:24:    left side has type restricted __le32
> drivers/ieee1394/dv1394.c:2121:24:    right side has type int
> drivers/ieee1394/dv1394.c:2123:24: warning: invalid assignment: |=
> drivers/ieee1394/dv1394.c:2123:24:    left side has type restricted __le32
> drivers/ieee1394/dv1394.c:2123:24:    right side has type int
> 
> Which looks like a real bug on a big-endian arch as it would set/clear
> the wrong bit.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/ieee1394/dv1394.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
> index f258e61..a329e6b 100644
> --- a/drivers/ieee1394/dv1394.c
> +++ b/drivers/ieee1394/dv1394.c
> @@ -2110,17 +2110,17 @@ static void ir_tasklet_func(unsigned long data)
>  			f = video->frames[next_i / MAX_PACKETS];
>  			next = &(f->descriptor_pool[next_i % MAX_PACKETS]);
>  			next_dma = ((unsigned long) block - (unsigned long) f->descriptor_pool) + f->descriptor_pool_dma;
> -			next->u.in.il.q[0] |= 3 << 20; /* enable interrupt */
> -			next->u.in.il.q[2] = 0; /* disable branch */
> +			next->u.in.il.q[0] |= cpu_to_le32(3 << 20); /* enable interrupt */
> +			next->u.in.il.q[2] = cpu_to_le32(0); /* disable branch */
>  
>  			/* link previous to next */
>  			prev_i = (next_i == 0) ? (MAX_PACKETS * video->n_frames - 1) : (next_i - 1);
>  			f = video->frames[prev_i / MAX_PACKETS];
>  			prev = &(f->descriptor_pool[prev_i % MAX_PACKETS]);
>  			if (prev_i % (MAX_PACKETS/2)) {
> -				prev->u.in.il.q[0] &= ~(3 << 20); /* no interrupt */
> +				prev->u.in.il.q[0] &= ~cpu_to_le32(3 << 20); /* no interrupt */
>  			} else {
> -				prev->u.in.il.q[0] |= 3 << 20; /* enable interrupt */
> +				prev->u.in.il.q[0] |= cpu_to_le32(3 << 20); /* enable interrupt */
>  			}
>  			prev->u.in.il.q[2] = cpu_to_le32(next_dma | 1); /* set Z=1 */
>  			wmb();

Looks like a bug + correct fix indeed.  Apparently dv1394 was never used on big
endian PCs.  Which is good, because we want to phase out dv1394 eventually.
-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/
