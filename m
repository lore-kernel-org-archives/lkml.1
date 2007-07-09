Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbXGIBAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbXGIBAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 21:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038AbXGIBA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 21:00:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:15087 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbXGIBAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 21:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RH5dg5bu8J2+tbQAxmU2wgr5Qxv9PiopKpsVMApbvYCORHNT43z3ZbJ9wzLOdz7VJ0ikUffxrC9fo/DouTxtcOZwRg5JInYRAaQ3TYEuLGQOFoS3BhpUJ44kzwAO2PVGt/yXRW1/8eAjoOUu70DNyuRCF1p4ThowyzoxlIeMMXU=
Message-ID: <41840b750707081800g1465eeeet12365fed84241c29@mail.gmail.com>
Date: Sun, 8 Jul 2007 21:00:24 -0400
From: "Shem Multinymous" <multinymous@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [Hdaps-devel] [PATCH] hdaps - switch to using input-polldev
Cc: hdaps-devel@lists.sourceforge.net, rlove@rlove.org,
       "Linux Kernel ML" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Michael Riepe" <michael@mr511.de>,
       "Henrique de Moraes Holschuh" <hmh@debian.org>
In-Reply-To: <200705252354.43730.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705252354.43730.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> HWMON: hdaps - convert to use input-polldev.
>
> Switch to using input-polldev skeleton instead of implementing
> polling loop by itself. This also fixes problem with trylock
> on a mutex in atomic context.
>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

There's a couple of inherent problems with this patch (now in -mm).

First, the hdaps driver regularly polls the embedded controller, which
in turns regularly polls the hardware. If the two polling rates differ
or fluctuate, we lose events. AFAICT, the delayed workqueues used by
input-polldev can get very laggy under load. That's very bad for
sensitive clients like hdapsd (the hard disk shock protection daemon).

Second, this is incompatible with the much-needed addition of a 2nd
input device relying on the same data. The existing hdaps input device
does "joystick emulation", i.e., reports values after calibration and
fuzzing. Userspace programs that need the raw data, like hdapsd,
currently have to poll the sysfs attribute, which is inefficient,
lag-prone and induces unnecessary interrupts on tickless sytems. To
solve this we'll have to add a 2nd input device to hdaps, for
reporting the raw accelerometer data. (Michael Riepe and me are now
working on such a patch.) But these two input devices need to share
their polling of the underlying EC hardware, and this is impossible
using input-polldev.

Since this patch will  degrade accuracy and will eventually be
reverted anyway, I suggest retracting it.

As for the mutex in atomic context issue, isn't it best addressed by
making mutex_trylock() do the sensible thing in softirqt?

  Shem
