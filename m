Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbZJGD5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbZJGD5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZJGD5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:57:32 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:47045 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZJGD5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:57:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=STp7WvQF/LxKtCwZ/7vFKk+4FYglEoT5i7A2VFlBFvNO6qHjZ+2yMouFZNTUwa63YX
         /K6qkJP5gZPF7UBlqcYKa6dUQn92fKhPABGCPbye8IsS9FRKI1grxJO0ixzePlHg1Est
         F5CONei0OwqC+4TY/2FH6cCYTshW9vSScahvU=
MIME-Version: 1.0
In-Reply-To: <1254341346-11367-1-git-send-email-jglisse@redhat.com>
References: <1254341346-11367-1-git-send-email-jglisse@redhat.com>
Date: Wed, 7 Oct 2009 13:56:54 +1000
Message-ID: <21d7e9970910062056r12754a6ew2c89b6f5a80e290a@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon/kms: Convert RS600 to new init path
From: Dave Airlie <airlied@gmail.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 1, 2009 at 6:09 AM, Jerome Glisse <jglisse@redhat.com> wrote:
> New init path allow to simply asic initialization and make easier
> to trace what happen on each different asic. We are removing most
> callback. Do a massive RS600 register cleanup to clarify RS600
> register, we are still bit fuzy on some register and waiting for
> more informations. I don't have hw to test, so this patch is a
> best effort to not break anythings and to try to improve things.

This patch breaks irq handling on all rs600->r5xx chips.
>  }
>
>  static inline uint32_t rs600_irq_ack(struct radeon_device *rdev, u32 *r500_disp_int)
>  {
> -       uint32_t irqs = RREG32(RADEON_GEN_INT_STATUS);

^ this was perfectly fine correct code.

> -       uint32_t irq_mask = RADEON_SW_INT_TEST;
> -
> -       if (irqs & AVIVO_DISPLAY_INT_STATUS) {
> -               *r500_disp_int = RREG32(AVIVO_DISP_INTERRUPT_STATUS);
> -               if (*r500_disp_int & AVIVO_D1_VBLANK_INTERRUPT) {
> -                       WREG32(AVIVO_D1MODE_VBLANK_STATUS, AVIVO_VBLANK_ACK);
> +       uint32_t irqs = RREG32(R_000040_GEN_INT_CNTL);

^ this is not doing the same thing at all.

If these auto generated registers are meant to have made life easier I can't see
how I'm wasting more time tracking down bugs that weren't there before this,
than fixing real problems. I'm about 5 mins from reverting back to
just using radeon_reg.h

Dave.
