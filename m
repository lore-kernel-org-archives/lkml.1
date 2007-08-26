Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbXHZPVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbXHZPVx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 11:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbXHZPVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 11:21:44 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:55819 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbXHZPVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 11:21:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=stvfjUOEJEpMC0zmkzo/1gdPOj8Y7zrdKztLfgrAOcNXhWfFJkTPjoLYKmM36rQvcK9IRYBp6XAd8FVPYtvGkwrFib1vlE4XK40tunJEzVq7Dinz70KDbJxTdIioJ42Mb8y7urIA6J1oYXMXv3i5JU9FVcAuJuzOQpEm+K9tOfw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] debloat aic7xxx and aic79xx drivers by deinlining
Date: Sun, 26 Aug 2007 16:21:30 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, hare@suse.de
References: <200708252257.07241.vda.linux@googlemail.com> <20070825145742.69b99168@laptopd505.fenrus.org>
In-Reply-To: <20070825145742.69b99168@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708261621.30563.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 August 2007 22:57, Arjan van de Ven wrote:
> On Sat, 25 Aug 2007 22:57:07 +0100
>
> Denys Vlasenko <vda.linux@googlemail.com> wrote:
> > Hi,
> >
> > Attached patch deinlines and moves big functions from .h to .c files
> > in drivers/scsi/aic7xxx/*. I also had to add prototypes for
> > ahc_lookup_scb and ahd_lookup_scb to .h files.
>
> one question... how many of these can actually be static (or would be
> if they were in their only-caller-c-file) ?

Seeing this patch ignored two or three times already,
I tried to make as non-intrusive change as possible,
thus maximizing the chances that it will be applied.

Come on, this patch saves 60k-90k of text, or 30-40% of driver size.
This is ridiculous to have such enormous bloat.

In the functions I converted there are no non-static functions
which are not declared in a .h file.

There are indeed functions which are used only in one .c file:

ahc_check_cmdcmpltqueues: aic7xxx_core.c
ahc_get_sense_bufaddr: aic7xxx_core.c
ahc_hscb_busaddr: aic7xxx_core.c
ahc_inq: aic7xxx_core.c
ahc_outq: aic7xxx_core.c
ahc_pause_bug_fix: aic7xxx_core.c
ahc_sg_bus_to_virt: aic7xxx_core.c
ahc_sg_virt_to_bus: aic7xxx_core.c
ahc_swap_with_next_hscb: aic7xxx_core.c
ahc_sync_qoutfifo: aic7xxx_core.c
ahc_sync_scb: aic7xxx_core.c
ahc_sync_tqinfifo: aic7xxx_core.c
ahc_targetcmd_offset: aic7xxx_core.c
ahc_update_residual: aic7xxx_core.c
ahd_assert_modes: aic79xx_core.c
ahd_check_cmdcmpltqueues: aic79xx_core.c
ahd_get_hescb_qoff: aic79xx_core.c
ahd_get_hnscb_qoff: aic79xx_core.c
ahd_get_sdscb_qoff: aic79xx_core.c
ahd_get_sescb_qoff: aic79xx_core.c
ahd_get_snscb_qoff: aic79xx_core.c
ahd_inl_scbram: aic79xx_core.c
ahd_inq: aic79xx_core.c
ahd_inq_scbram: aic79xx_core.c
ahd_outq: aic79xx_core.c
ahd_set_hescb_qoff: aic79xx_core.c
ahd_set_hnscb_qoff: aic79xx_core.c
ahd_set_sdscb_qoff: aic79xx_core.c
ahd_set_sescb_qoff: aic79xx_core.c
ahd_set_snscb_qoff: aic79xx_core.c
ahd_setup_data_scb: aic79xx_core.c
ahd_setup_noxfer_scb: aic79xx_core.c
ahd_setup_scb_common: aic79xx_core.c
ahd_sg_bus_to_virt: aic79xx_core.c
ahd_sg_virt_to_bus: aic79xx_core.c
ahd_swap_with_next_hscb: aic79xx_core.c
ahd_sync_qoutfifo: aic79xx_core.c
ahd_sync_scb: aic79xx_core.c
ahd_sync_sense: aic79xx_core.c
ahd_sync_tqinfifo: aic79xx_core.c
ahd_targetcmd_offset: aic79xx_core.c
ahd_update_modes: aic79xx_core.c

Converting them to static may save additional 3 or 4k,
if gcc will be smart enough...

I, too, have many questions regarding this driver:
why __inline? why u_int?... and who's maintainer, btw?

> Did you run the find static
> script or are you waiting for Adrian to do that ;-)

$ find -name '*find*static*'
$
--
vda
