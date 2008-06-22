Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbYFVTaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbYFVTaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYFVT3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:29:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:37147 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbYFVT3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:29:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=NP+JgpBf38GC8tNA/7zl0ILAgE8zfrgMP6SugRxgjRIdPDZH6J3Vu/HC7zPcqm1NEK
         xaLblVrjUzG5jR9U5A3TqPQrY8QRoaWJ+h6GlN2lsEn3ThqL4pvebqteGSYIdy6OBXHL
         qhhFaIBSj9mlhcy3eE8wm+u27mjfMYfXe1AiA=
Message-ID: <84144f020806221229r683b07d9i3297c396a29e69f1@mail.gmail.com>
Date: Sun, 22 Jun 2008 22:29:53 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 3/3] relay: Add buffer-only channels; useful for early logging.
Cc: tzanussi@gmail.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080621171149.1434e523@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621171149.1434e523@linux360.ro>
X-Google-Sender-Auth: 6169f443b2a237c8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 5:11 PM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> Allows one to create and use a channel with no associated files. Files
> can be initialized later. This is useful in scenarios such as logging
> in early code, before VFS is up. Therefore, such channels can be
> created and used as soon as kmem_cache_init() completed.
>
> This is needed by kmemtrace to do tracing in early kernel code.
>
> +static int relay_setup_buf_file(struct rchan *chan,
> +                               struct rchan_buf *buf,
> +                               unsigned int cpu)
> +{
> +       struct dentry *dentry;
> +       unsigned long flags;
> +       char *tmpname;
> +
> +       tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
> +       if (!tmpname)
> +               goto failed;

Why don't you return -ENOMEM here?

> +       snprintf(tmpname, NAME_MAX, "%s%d", chan->base_filename, cpu);
> +
> +       /* Create file in fs */
> +       dentry = chan->cb->create_buf_file(tmpname, chan->parent,
> +                                          S_IRUSR, buf,
> +                                          &chan->is_global);
> +
> +       kfree(tmpname);
> +
> +       if (!dentry)
> +               goto failed;

And here?

> +       spin_lock_irqsave(&buf->rw_lock, flags);
> +       buf->dentry = dentry;
> +       buf->dentry->d_inode->i_size = buf->early_bytes;
> +       spin_unlock_irqrestore(&buf->rw_lock, flags);
> +
> +       return 0;
> +
> +failed:
> +       return 1;

The separate goto seems pointless. Why don't you use negative return
values for error handling?

> +}
> +
>  /*
>  *     relay_open_buf - create a new relay channel buffer
>  *
> @@ -415,48 +448,33 @@ EXPORT_SYMBOL_GPL(relay_reset);
>  static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
>  {
>        struct rchan_buf *buf = NULL;
> -       struct dentry *dentry;
> -       char *tmpname;
>
>        if (chan->is_global)
>                return chan->buf[0];
>
> -       tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
> -       if (!tmpname)
> -               goto end;
> -       snprintf(tmpname, NAME_MAX, "%s%d", chan->base_filename, cpu);
> -
>        buf = relay_create_buf(chan);
>        if (!buf)
> -               goto free_name;
> +               return NULL;
>
>        spin_lock_init(&buf->rw_lock);
>
> +       if (chan->has_base_filename)
> +               if (relay_setup_buf_file(chan, buf, cpu))
> +                       goto free_buf;
> +
>        buf->cpu = cpu;
>        __relay_reset(buf, 1);
>
> -       /* Create file in fs */
> -       dentry = chan->cb->create_buf_file(tmpname, chan->parent, S_IRUSR,
> -                                          buf, &chan->is_global);
> -       if (!dentry)
> -               goto free_buf;
> -
> -       buf->dentry = dentry;
> -
>        if(chan->is_global) {
>                chan->buf[0] = buf;
>                buf->cpu = 0;
>        }
>
> -       goto free_name;
> +       return buf;
>
>  free_buf:
>        relay_destroy_buf(buf);
> -       buf = NULL;
> -free_name:
> -       kfree(tmpname);
> -end:
> -       return buf;
> +       return NULL;
>  }
>
>  /**
> @@ -539,8 +557,8 @@ static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
>
>  /**
>  *     relay_open - create a new relay channel
> - *     @base_filename: base name of files to create
> - *     @parent: dentry of parent directory, %NULL for root directory
> + *     @base_filename: base name of files to create, %NULL for buffering only
> + *     @parent: dentry of parent directory, %NULL for root directory or buffer
>  *     @subbuf_size: size of sub-buffers
>  *     @n_subbufs: number of sub-buffers
>  *     @cb: client callback functions
> @@ -562,8 +580,6 @@ struct rchan *relay_open(const char *base_filename,
>  {
>        unsigned int i;
>        struct rchan *chan;
> -       if (!base_filename)
> -               return NULL;
>
>        if (!(subbuf_size && n_subbufs))
>                return NULL;
> @@ -578,7 +594,10 @@ struct rchan *relay_open(const char *base_filename,
>        chan->alloc_size = FIX_SIZE(subbuf_size * n_subbufs);
>        chan->parent = parent;
>        chan->private_data = private_data;
> -       strlcpy(chan->base_filename, base_filename, NAME_MAX);
> +       if (base_filename) {
> +               chan->has_base_filename = 1;
> +               strlcpy(chan->base_filename, base_filename, NAME_MAX);
> +       }
>        setup_callbacks(chan, cb);
>        kref_init(&chan->kref);
>
> @@ -607,6 +626,62 @@ free_bufs:
>  EXPORT_SYMBOL_GPL(relay_open);
>
>  /**
> + *     relay_late_setup_files - triggers file creation
> + *     @chan: channel to operate on
> + *     @base_filename: base name of files to create
> + *     @parent: dentry of parent directory, %NULL for root directory
> + *
> + *     Returns 0 if successful, non-zero otherwise.
> + *
> + *     Use to setup files for a previously buffer-only channel.
> + *     Useful to do early tracing in kernel, before VFS is up, for example.
> + */
> +int relay_late_setup_files(struct rchan *chan,
> +                          const char *base_filename,
> +                          struct dentry *parent)
> +{
> +       unsigned int i;
> +       int err;
> +       struct rchan_buf *buf;
> +
> +       if (!chan || !base_filename)
> +               return 1;

-EINVAL?

> +
> +       strlcpy(chan->base_filename, base_filename, NAME_MAX);
> +
> +       mutex_lock(&relay_channels_mutex);
> +       if (unlikely(chan->has_base_filename))
> +               goto out;

-EINVAL?

> +       chan->has_base_filename = 1;
> +       chan->parent = parent;
> +       /*
> +        * The CPU hotplug notifier ran before us and created buffers with
> +        * no files associated. So it's safe to call relay_setup_buf_file()
> +        * on all currently online CPUs.
> +        */
> +       for_each_online_cpu(i) {
> +               buf = chan->buf[i];
> +
> +               if (unlikely(!buf)) {
> +                       printk(KERN_ERR "relay_late_setup_files: "
> +                              "all CPUs should have buffers!\n");
> +                       goto out;
> +               }
> +
> +               err = relay_setup_buf_file(chan, buf, i);
> +               if (unlikely(err))
> +                       goto out;
> +       }
> +       mutex_unlock(&relay_channels_mutex);
> +
> +       return 0;
> +
> +out:
> +       mutex_unlock(&relay_channels_mutex);
> +       return 1;

You don't need two return statements (and coincidentally two unlocks)
if you keep the return value in a local variable 'err'.

> +}
> +
> +/**
>  *     relay_switch_subbuf - switch to a new sub-buffer
>  *     @buf: channel buffer
>  *     @length: size of current event
> @@ -629,8 +704,13 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
>                old_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
>                buf->padding[old_subbuf] = buf->prev_padding;
>                buf->subbufs_produced++;
> -               buf->dentry->d_inode->i_size += buf->chan->subbuf_size -
> -                       buf->padding[old_subbuf];
> +               if (buf->dentry)
> +                       buf->dentry->d_inode->i_size +=
> +                               buf->chan->subbuf_size -
> +                               buf->padding[old_subbuf];
> +               else
> +                       buf->early_bytes += buf->chan->subbuf_size -
> +                                           buf->padding[old_subbuf];
>                smp_mb();
>                if (waitqueue_active(&buf->read_wait))
>                        /*
> @@ -1241,9 +1321,8 @@ EXPORT_SYMBOL_GPL(relay_file_operations);
>
>  static __init int relay_init(void)
>  {
> -
>        hotcpu_notifier(relay_hotcpu_callback, 0);
>        return 0;
>  }
>
> -module_init(relay_init);
> +early_initcall(relay_init);
> --
> 1.5.5.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
