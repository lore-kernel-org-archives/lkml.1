Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZHFR4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZHFR4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 13:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbZHFR4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 13:56:13 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:50893 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZHFR4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 13:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=fmmscdkvqtMm7dU18ZvQeMtYdO3c/kODjW1hdIDLnzxD6tl05QM0lgTM0SKUrrk6T/
         p9Th4M4f8QVZ3MPVG9p0sYBL5hL7ob6F/09F60VfvLEL1Jz64ctfXrZ5PQsPpiMfCFmH
         pnEFnOUI5nJTm44Tzvr9Dc2t3QOdaW2pligBY=
MIME-Version: 1.0
Date: Thu, 6 Aug 2009 13:56:12 -0400
Message-ID: <b4198de60908061056m2b27402cjd25f94b6bbed0707@mail.gmail.com>
Subject: Bad Code generated from __{get,put}_unaligned functions
From: Matt Turner <mattst88@gmail.com>
To: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was researching different ways of writing unaligned load/store
macros, so I checked how the kernel did it -- the most general way
possible. See include/linux/unaligned.h. As such, very bad code is
generated, for example on alpha with BWX, we can implement all these
functions with a single instruction, whereas we get stuff like this
generated from the generic functions.

__get_unaligned_le32:
    .frame $30,0,$26,0
    .prologue 0
    ldbu $0,1($16)
    ldbu $1,2($16)
    ldbu $2,3($16)
    ldbu $3,0($16)
    sll $1,16,$1
    sll $0,8,$0
    bis $0,$1,$0
    sll $2,24,$2
    bis $0,$3,$0
    bis $0,$2,$0
    addl $31,$0,$0
    ret $31,($26),1

4 load byte instructions, shift, shift, or, shift, or, or, sign extend
-- or ldl_u instruction. The code is more than doubly-bad for le64.

Do we use the generic functions for a reason I don't see? It appears
that it would be easy enough to add architecture-specific unaligned
get/put functions in arch/*/include/asm/unaligned.h

CC me on replies please.

Matt Turner
