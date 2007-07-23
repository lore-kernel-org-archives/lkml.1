Return-Path: <linux-kernel-owner+w=401wt.eu-S935873AbXGWVAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935873AbXGWVAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964781AbXGWU7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:59:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:9377 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964783AbXGWU71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:59:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ABwnaZwLnhUDL0Y7qc8enD+Q8o78KN4bTeIylWB9NxcmlttpBM9AgRZ+5XntZPGAIVBRysMtwbYJV/Xh3pyw6VglSXDkOfQHjO2p1BzviTaHb+5xj2rq4mXlwdyrQeFzhZWjEye63SB6LgMuKrhZgD+G+4gbh3ySDEzxK0VHRLw=
Message-ID: <9a8748490707231359x2e5b4e61p614dcdc9ff3b1a42@mail.gmail.com>
Date: Mon, 23 Jul 2007 22:59:25 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jens Axboe" <axboe@kernel.dk>, "Andrew Morton" <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>, drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
In-Reply-To: <20070721203819.GA10706@mail.linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070721203819.GA10706@mail.linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/07, Lars Ellenberg <lars@linbit.com> wrote:
>
>         DRBD wants to go mainline.
>         please have a look at the "for-linus" branch of
>         git://git.drbd.org/home/git/linux-drbd.git.
>
A few more comments.

In drbd_main.c::after_state_ch() there's this code :

...
                if ( mdev->p_uuid ) {
                        kfree(mdev->p_uuid);
                        mdev->p_uuid = NULL;
                }
...

Since kfree(NULL) if a noop, that should just become :

...
                kfree(mdev->p_uuid);
                mdev->p_uuid = NULL;
...


Same for these bits in drbd_main.c::drbd_cleanup()

...
                        if(mdev->app_reads_hash) {
                                kfree(mdev->app_reads_hash);
                                mdev->app_reads_hash = NULL;
                        }
                        if ( mdev->p_uuid ) {
                                kfree(mdev->p_uuid);
                                mdev->p_uuid = NULL;
                        }
...

They should just become

...
                        kfree(mdev->app_reads_hash);
                        mdev->app_reads_hash = NULL;
                        kfree(mdev->p_uuid);
                        mdev->p_uuid = NULL;
...

And then there's drbd_main.c::drbd_new_device() :

...
                if(mdev->app_reads_hash) kfree(mdev->app_reads_hash);
...

That should just be

...
                kfree(mdev->app_reads_hash);
...

Btw; You shouldn't put multiple statements on the same line. That is
seen all over the place - like

        mdev = kzalloc(sizeof(drbd_dev),GFP_KERNEL);
        if(!mdev) goto Enomem;

That should be

        mdev = kzalloc(sizeof(drbd_dev),GFP_KERNEL);
        if(!mdev)
                goto Enomem;

There are lots of other examples.


Here are a few more pointless NULL checks before kfree() :

drbd_nl.c::drbd_nl_net_conf() :
...
        if(new_tl_hash) {
                if (mdev->tl_hash) kfree(mdev->tl_hash);
                mdev->tl_hash_s = mdev->net_conf->max_epoch_size/8;
                mdev->tl_hash = new_tl_hash;
        }

        if(new_ee_hash) {
                if (mdev->ee_hash) kfree(mdev->ee_hash);
                mdev->ee_hash_s = mdev->net_conf->max_buffers/8;
                mdev->ee_hash = new_ee_hash;
        }

        if ( mdev->cram_hmac_tfm ) {
                crypto_free_hash(mdev->cram_hmac_tfm);
        }
        mdev->cram_hmac_tfm = tfm;
...

should become :

...
        if(new_tl_hash) {
                kfree(mdev->tl_hash);
                mdev->tl_hash_s = mdev->net_conf->max_epoch_size/8;
                mdev->tl_hash = new_tl_hash;
        }

        if(new_ee_hash) {
                kfree(mdev->ee_hash);
                mdev->ee_hash_s = mdev->net_conf->max_buffers/8;
                mdev->ee_hash = new_ee_hash;
        }

        crypto_free_hash(mdev->cram_hmac_tfm);
        mdev->cram_hmac_tfm = tfm;
...

still in drbd_nl.c::drbd_nl_net_conf() :

...
  fail:
        if (tfm) crypto_free_hash(tfm);
        if (new_tl_hash) kfree(new_tl_hash);
        if (new_ee_hash) kfree(new_ee_hash);
        if (new_conf) kfree(new_conf);
...

should become

...
  fail:
        crypto_free_hash(tfm);
        kfree(new_tl_hash);
        kfree(new_ee_hash);
        kfree(new_conf);
...

drbd_nl.c::ensure_mdev() :

...
                        if(mdev->app_reads_hash) kfree(mdev->app_reads_hash);
..

becomes

...
                        kfree(mdev->app_reads_hash);
...


In drbd_receiver.c::receive_uuids() we find this :

...
        if ( mdev->p_uuid ) kfree(mdev->p_uuid);
...

which should be just

...
        kfree(mdev->p_uuid);
...

There is also drbd_receiver.c::drbd_disconnect() - where

...
        if ( mdev->p_uuid ) {
                kfree(mdev->p_uuid);
                mdev->p_uuid = NULL;
        }
...

needs to become just

...
        kfree(mdev->p_uuid);
        mdev->p_uuid = NULL;
...


And in drbd_receiver.c::drbd_do_auth()

...
 fail:
        if(peers_ch) kfree(peers_ch);
        if(response) kfree(response);
        if(right_response) kfree(right_response);

...

needs to be turned into

...
 fail:
        kfree(peers_ch);
        kfree(response);
        kfree(right_response);
...


drbd_req.c::drbd_make_request_common() also needs to get rid of

...
        if (b) kfree(b); /* if someone else has beaten us to it... */
...
  fail_and_free_req:
        if (b) kfree(b);
...


and just turn it into

...
        kfree(b); /* if someone else has beaten us to it... */
...
  fail_and_free_req:
        kfree(b);
...


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
