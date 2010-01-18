Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336Ab0ARMyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0ARMyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874Ab0ARMyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:54:20 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59766 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab0ARMyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:54:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HZh9AUaGvQrTwzl1A8fwskEKu5REmt9RE5sKLGi09JX24w67iigmgmE/QDCWKb8UuK
         yVhpranAsSsTn6l66mVhLKsWYfZlR7cfMBmfNdcbMQPbwlE707+whvfuFMNle1E8oxin
         XHd9S4sBySl8zC2oC6SQ/jt2UIv77DowVU6sU=
MIME-Version: 1.0
In-Reply-To: <1263816096-22310-1-git-send-email-jglisse@redhat.com>
References: <1263816096-22310-1-git-send-email-jglisse@redhat.com>
Date: Mon, 18 Jan 2010 13:54:17 +0100
Message-ID: <68676e01001180454v20b15325oab4c4229e3ca1dbf@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon: r6xx/r7xx possible security issue, system ram 
	access
From: Luca Tettamanti <kronos.it@gmail.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: airlied@gmail.com, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o0ICtP54022326

On Mon, Jan 18, 2010 at 1:01 PM, Jerome Glisse <jglisse@redhat.com> wrote:> This patch workaround a possible security issue which can allow> user to abuse drm on r6xx/r7xx hw to access any system ram memory.[...]> diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c> index 44060b9..edafc7b 100644> --- a/drivers/gpu/drm/radeon/r600_cs.c> +++ b/drivers/gpu/drm/radeon/r600_cs.c> @@ -503,9 +531,61 @@ static int r600_packet3_check(struct radeon_cs_parser *p,>                for (i = 0; i < pkt->count; i++) {>                        reg = start_reg + (4 * i);>                        switch (reg) {> +                       /* This register were added late, there is userspace> +                        * which does provide relocation for those but set> +                        * 0 offset. In order to avoid breaking old userspace> +                        * we detect this and set address to point to last> +                        * CB_COLOR0_BASE, note that if userspace doesn't set> +                        * CB_COLOR0_BASE before this register we will report> +                        * error. Old userspace always set CB_COLOR0_BASE> +                        * before any of this.> +                        */> +                       case R_0280E0_CB_COLOR0_FRAG:> +                       case R_0280E4_CB_COLOR1_FRAG:> +                       case R_0280E8_CB_COLOR2_FRAG:> +                       case R_0280EC_CB_COLOR3_FRAG:> +                       case R_0280F0_CB_COLOR4_FRAG:> +                       case R_0280F4_CB_COLOR5_FRAG:> +                       case R_0280F8_CB_COLOR6_FRAG:> +                       case R_0280FC_CB_COLOR7_FRAG:> +                       case R_0280C0_CB_COLOR0_TILE:> +                       case R_0280C4_CB_COLOR1_TILE:> +                       case R_0280C8_CB_COLOR2_TILE:> +                       case R_0280CC_CB_COLOR3_TILE:> +                       case R_0280D0_CB_COLOR4_TILE:> +                       case R_0280D4_CB_COLOR5_TILE:> +                       case R_0280D8_CB_COLOR6_TILE:> +                       case R_0280DC_CB_COLOR7_TILE:> +                               if (!r600_cs_packet_next_is_pkt3_nop(p)) {> +                                       if (!track->cb_color0_base_last) {> +                                               dev_err(p->dev, "Broken old userspace ? no cb_color0_base supplied"> +                                                       "before trying to write 0x%08X\n", reg);
Cosmetic issue: a space is missing between "supplied" and "before".
Luca���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
