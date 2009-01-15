Return-Path: <linux-kernel-owner+w=401wt.eu-S1760894AbZAOPrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbZAOPrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 10:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbZAOPrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 10:47:21 -0500
Received: from adelie.canonical.com ([91.189.90.139]:57300 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbZAOPrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:47:21 -0500
Date: Thu, 15 Jan 2009 15:47:17 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Harald Welte <laforge@gnumonks.org>
Cc: linux-kernel@vger.kernel.org
Subject: panasonic-laptop driver oddity
Message-ID: <20090115154717.GC6896@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have been looking at your panasonic-laptop driver with a view to
back porting it to 2.6.27, and the following inconsistancy was pointed
out to me.  In bl_set_status() we ensure that bright is no lower than
sinf[SINF_AC_MIN_BRIGHT] and sinf[SINF_DC_MIN_BRIGHT], and then check if
it is lower than sinf[SINF_AC_MIN_BRIGHT].  That seems redundant.


    static int bl_set_status(struct backlight_device *bd)
    {
        struct pcc_acpi *pcc = bl_get_data(bd);
        int bright = bd->props.brightness;
        int rc;

        if (!acpi_pcc_retrieve_biosdata(pcc, pcc->sinf))
                return -EIO;

        if (bright < pcc->sinf[SINF_AC_MIN_BRIGHT])
                bright = pcc->sinf[SINF_AC_MIN_BRIGHT];

        if (bright < pcc->sinf[SINF_DC_MIN_BRIGHT])
                bright = pcc->sinf[SINF_DC_MIN_BRIGHT];

        if (bright < pcc->sinf[SINF_AC_MIN_BRIGHT] ||
            bright > pcc->sinf[SINF_AC_MAX_BRIGHT])
                return -EINVAL;

We could not decide if this was simply belt and braces to constrain the
value, or if this should be a check against sinf[SINF_DC_MAX_BRIGHT].
Perhaps you could clarify?

-apw
