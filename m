Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYFVUvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYFVUvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYFVUvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:51:41 -0400
Received: from [194.117.236.238] ([194.117.236.238]:39550 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbYFVUvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:51:40 -0400
Date: Sun, 22 Jun 2008 23:51:22 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: tzanussi@gmail.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] relay: Add buffer-only channels; useful for early
 logging.
Message-ID: <20080622235122.0dc0f724@linux360.ro>
In-Reply-To: <84144f020806221229r683b07d9i3297c396a29e69f1@mail.gmail.com>
References: <20080621171149.1434e523@linux360.ro>
	<84144f020806221229r683b07d9i3297c396a29e69f1@mail.gmail.com>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 22:29:53 +0300
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On Sat, Jun 21, 2008 at 5:11 PM, Eduard - Gabriel Munteanu
> <eduard.munteanu@linux360.ro> wrote:
> > +       tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
> > +       if (!tmpname)
> > +               goto failed;
> 
> Why don't you return -ENOMEM here?

The original function from which I ripped this thing off
(relay_open_buf()) returned 1 on error, so I assumed I wasn't supposed
to change this behavior.

I should probably do this in a separate patch.

> The separate goto seems pointless. Why don't you use negative return
> values for error handling?

Yes, it's better to use 'return' directly.

> >  /**
> > + *     relay_late_setup_files - triggers file creation
> > + *     @chan: channel to operate on
> > + *     @base_filename: base name of files to create
> > + *     @parent: dentry of parent directory, %NULL for root
> > directory
> > + *
> > + *     Returns 0 if successful, non-zero otherwise.
> > + *
> > + *     Use to setup files for a previously buffer-only channel.
> > + *     Useful to do early tracing in kernel, before VFS is up, for
> > example.
> > + */
> > +int relay_late_setup_files(struct rchan *chan,
> > +                          const char *base_filename,
> > +                          struct dentry *parent)
> > +{
> > +       unsigned int i;
> > +       int err;
> > +       struct rchan_buf *buf;
> > +
> > +       if (!chan || !base_filename)
> > +               return 1;
> 
> -EINVAL?

Will do and resubmit. Being new code (called directly by other kernel
users), it allows me to be a bit inconsistent about return values.

> > +               err = relay_setup_buf_file(chan, buf, i);
> > +               if (unlikely(err))
> > +                       goto out;
> > +       }
> > +       mutex_unlock(&relay_channels_mutex);
> > +
> > +       return 0;
> > +
> > +out:
> > +       mutex_unlock(&relay_channels_mutex);
> > +       return 1;
> 
> You don't need two return statements (and coincidentally two unlocks)
> if you keep the return value in a local variable 'err'.

Thanks, I missed this possibility. Sounds better.
 

	Eduard
