Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab0CEP4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:56:13 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:49849 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab0CEP4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:56:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=Q3LCWwCD5uOwLxLdJtMBlafQOFmiQl+fbgyQ0KR0LW3o/WPwWhSpJirnh4JLAQ0IeW
         1Vzx8HkE50l3oVxdFSSdGoIZCwF8oYIl+tPSa7u3xJjE9C1y5QDPTKqutzcu23B5an0J
         51OmFpfZEl7PW46CGxPxALIwH6V5wdGmGH4s0=
MIME-Version: 1.0
In-Reply-To: <20100305154009.GC2505@tempa>
References: <20100305123834.0d9c6277@lxorguk.ukuu.org.uk>
	 <20100305.063718.211238119.davem@davemloft.net>
	 <20100305151754.GB2505@tempa>
	 <20100305.072612.186421758.davem@davemloft.net>
	 <20100305154009.GC2505@tempa>
Date: Fri, 5 Mar 2010 16:56:10 +0100
Message-ID: <ff13bc9a1003050756rca44e03uffbfa3090f96e0ac@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Luca Barbieri <luca.barbieri@gmail.com>
To: Daniel Stone <daniel@fooishbar.org>, David Miller <davem@davemloft.net>,
       skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems to me that Linus' technical argument is indeed being mostly ignored.

While breaking the ABI is unfortunate, the real problem that Linus
complained about is that you can't install several userspace versions
side-by-side.

This means that if you install your new kernel and userspace, reboot,
and find the new kernel doesn't work for some reason, you can't just
go back to the old kernel and have working X, because you just
replaced userspace with a version that no longer works with the kernel
that worked correctly.

This is even worse for distributions that want to upgrade the kernel,
because each kernel package would need to have a Depends on the exact
userspace package version.
Thus, the package manager would remove the older kernel when the new
one is installed (since they depend on different versions of the same
userspace package).
If the new kernel somehow doesn't work, the user is totally screwed
and must reboot from a live CD.

As pointed out, in this case, it is relatively easy to solve by adding
a version number to libdrm-nouveau, the X driver and the DRI drivers.
X will then have to load the correct driver and give Mesa the DRI
driver name with the correct version appended.

It may be a good idea to do this before the new nouveau ABI gets
shipped in released distributions, and with a generic mechanisms that
can be used by all X/drm drivers.

Workarounds are possible, such as replacing /usr/bin/X with a script
that loads the correct version, or using X over /dev/fb0 (which should
work fine with any DRM KMS driver, and any non-DRI framebuffer), but
they shouldn't be needed.

BTW, the nVidia proprietary driver also ties the kernel and userspace
version in this way, and is actually worse because it replaces the X
libglx.so, breaking all other drivers.
