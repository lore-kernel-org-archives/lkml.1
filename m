Return-Path: <linux-kernel-owner+w=401wt.eu-S1759379AbZDLAzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbZDLAzu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 20:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZDLAz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 20:55:27 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:37997 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZDLAzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 20:55:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vu56TA3V3vZUItil6GwHG0tR1QYA6qpEZlvfcTEhihTcuzyIPmkgonQ6blSVHZRK7z
         LuCrsE6Rpa6akpYm2X22Ikqz8ebDL0VfqVUNKsm18RkUo6nN5U8TfGe7vJTr5t3iUajO
         ac+K9goggkBgr+reafv8qPrbANeMVBilhhw0I=
MIME-Version: 1.0
Date: Sat, 11 Apr 2009 20:55:23 -0400
Message-ID: <b4198de60904111755u5c2078c7xcc689dbd78aeb957@mail.gmail.com>
Subject: alpha: half done futex implementation
From: Matt Turner <mattst88@gmail.com>
To: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>,
       Jay Estabrook <jay.estabrook@hp.com>,
       Oliver Falk <oliver@linux-kernel.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Going on Richard's advice, I've tried to write an alpha futex
implementation based on the powerpc futex.h.

I've gotten this far.. :\

#define __futex_atomic_op(insn, ret, oldval, uaddr, oparg) \
    __asm__ __volatile(             \
    "1: ldl_l   %0,%2\n"            \
        insn                        \
    /* something needs to happen here
     * to save result of insn across
     * stl_c? */
    "   stl_c   %1,%2\n"            \
    "   beq     %1,2f\n"            \
    "   mb\n"                       \
    /* something needs to happen here
     * for the ret */
    "   .subsection 2\n"            \
    "2: br      1b\n"               \
    "   .previous\n"                \
    : "=&r" (oldval), "=&r" (ret)   \
    : "b" (uaddr) \
    : "memory")

Could someone take a look and help finish it?

For futex_atomic_cmpxchg_inatomic, I think Ivan's DRM_CAS
implementation can be used with only trivial changes. See
http://cgit.freedesktop.org/mesa/drm/commit/?id=6feac49398d0f037103a4ae3d5a512badeed61fb

Please CC me on responses, as I'm not subscribed to linux-kernel@.

Thanks,

Matt Turner
