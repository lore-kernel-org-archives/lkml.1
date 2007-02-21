Return-Path: <linux-kernel-owner+w=401wt.eu-S1422680AbXBUQzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422680AbXBUQzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422681AbXBUQzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:55:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:5104 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422680AbXBUQzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:55:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iqS0aqWCtHsu+2anhzYLMCU/5gIofIQEFpK3fNpVGDYF6FIQURMaFHC3ja558s5NbRm4Uu4keax0fcBpSEls27OGUGftIlhzVF0vUvIwJolog3vQjnIBqj18oPo+gTHW8Yka/nOEurq8fCgPHhaArHTu45oEbJuNOErH/x7lOfo=
Message-ID: <45a44e480702210855t344441c1xf8e081c82ece4e63@mail.gmail.com>
Date: Wed, 21 Feb 2007 11:55:17 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: [PATCH 2.6.20 1/1] fbdev,mm: hecuba/E-Ink fbdev driver
Cc: "Paul Mundt" <lethal@linux-sh.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Frame Buffer Device Development" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, "James Simmons" <jsimmons@infradead.org>
In-Reply-To: <Pine.LNX.4.62.0702200906070.2082@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070217104215.GB25512@localhost> <1171715652.5186.7.camel@lappy>
	 <45a44e480702170525n9a15fafpb370cb93f1c1fcba@mail.gmail.com>
	 <20070217135922.GA15373@linux-sh.org>
	 <45a44e480702180331t7e76c396j1a9861f689d4186b@mail.gmail.com>
	 <20070218235741.GA22298@linux-sh.org>
	 <45a44e480702192013s7d49d05ai31e576f0448a485e@mail.gmail.com>
	 <Pine.LNX.4.62.0702200906070.2082@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Don't you need a way to specify the maximum deferral time? E.g. a field in
> fb_info.
>

You are right. I will need that. I could put that into struct
fb_deferred_io. So drivers would setup like:

static struct fb_deferred_io hecubafb_defio = {
        .delay          = HZ,
        .deferred_io    = hecubafb_dpy_update,
};

where that would be:
struct fb_deferred_io {
        unsigned long delay;    /* delay between mkwrite and deferred handler */
        struct mutex lock;      /* mutex that protects the page list */
        struct list_head pagelist;      /* list of touched pages */
        struct delayed_work deferred_work;
        void (*deferred_io)(struct fb_info *info, struct list_head
*pagelist); /* callback */
};

and the driver would do:
...
info->fbdefio = hecubafb_defio;
register_framebuffer...

When the driver calls register_framebuffer and unregister_framebuffer,
I can then do the init and destruction of the other members of that
struct. Does this sound okay?

Thanks,
jaya
