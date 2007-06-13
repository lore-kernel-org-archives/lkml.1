Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbXFMUlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbXFMUlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbXFMUlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:41:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:60898 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbXFMUlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:41:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ik04mZP2eMsMLTkXMOHFaRqcT/RXzyt7vDjDFcKLpl9s752rPJcrzxhMC4HkACwVWc+ueNaxykBS0fdo5FikSyfJoTdZIIo+/59b2FXSqbOnY9Ky+rd9G4a+SUL1SMOtzfLN/Ta9GGjTbyC6qmmLLwcwSK4G/BJBLR320/K/AdM=
Message-ID: <a781481a0706131341k17170514q7a9d0ce052dbfe2a@mail.gmail.com>
Date: Thu, 14 Jun 2007 02:11:22 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Keiichi KII" <k-keiichi@bx.jp.nec.com>
Subject: Re: [RFC][PATCH -mm take5 6/7] add ioctls for adding/removing target
Cc: "Matt Mackall" <mpm@selenic.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <466FC76A.6050006@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466FC455.5060001@bx.jp.nec.com> <466FC76A.6050006@bx.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keiichi,

On 6/13/07, Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:
> From: Keiichi KII <k-keiichi@bx.jp.nec.com>
>
> We add ioctls for adding/removing target.
> If we use NETCONSOLE_ADD_TARGET ioctl,
> we can dynamically add netconsole target.
> If we use NETCONSOLE_REMOVE_TARGET ioctl,
> we can dynamically remoe netconsole target.

*ugh*. I was wondering what a show-stopper this particular patch
was -- introduces a couple of ioctl()'s, exports a new structure to
userspace, adds a hitherto-unneeded header file, brings in
tty_struct/tty_operations and ends up adding so much complexity/
bloat to netconsole.c. Not only that, it must live together (and
side-by-side) with the sysfs interface also, because the two of them
do different things: sysfs to be able to modify target parameters at
run-time and the ioctl()'s to dynamically add/remove targets. We
can't really mkdir(2) or rmdir(2) in sysfs so the ioctl()'s are needed.

So may I suggest:

Just lose *both* the sysfs and ioctl() interfaces and use _configfs_.
It is *precisely* the thing you need in your driver here -- the ability
to create / destroy kernel objects (or config_items in configfs lingo)
from _userspace_ via simple mkdir(2) and rmdir(2). And configfs
makes changing multiple configurable parameters atomically trivial
too, via rename(2) ... not to mention a sysfs+ioctls -> configfs
conversion would help your patchset lose some weight too :-)

Satyam
