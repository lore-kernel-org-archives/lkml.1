Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYFWUNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYFWUNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbYFWUNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:13:06 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:7219 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbYFWUNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IOQpsTfKQzHOe4SzVfZz2sFKD8CNEzHYfIe2iS+ak4AOdT7x3dFjl2JoZFnYSxzbPp
         LqYBQ0Zhvay8OzzavvOpx9G7tIw0FY+yHftIzQMxiga7NcQ2zR8geSvgTNkiPJD/VgAz
         o5o12YkkLMyn/YjAVcHYDpXsu6TJQEmSzlQK8=
Date: Mon, 23 Jun 2008 22:11:52 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Fix open/close race in saa7134
Message-ID: <20080623201132.GA6055@joi>
References: <20080622100507.779acc59@infradead.org> <20080622172826.GA7487@joi> <20080622105832.1c61fb92@infradead.org> <20080623184937.GA5593@joi> <20080623115432.5ce376e5@infradead.org> <20080623192141.GB5593@joi> <20080623125348.3133b30b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623125348.3133b30b@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 12:53:48PM -0700, Arjan van de Ven wrote:
> On Mon, 23 Jun 2008 21:22:03 +0200
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > 
> > If dev->empress_users could be > 1 then ok - it could break, but it
> > can only be 1 or 0. If it's 1 you won't open the device. If it's 0
> > you won't reach ts_close.
> > 
> > If you still see the race, please show me the sequence, because I
> > don't (of course when decrementing is the last operation of ts_close).
> 
> a decrement in C, without locking, is NOT atomic.

I know about it. But in this code, 2 threads cannot modify empress_users!
This variable should be named empress_used_now or something like that.

Look:

static int ts_open(struct inode *inode, struct file *file)
{
	(...)
	err = -EBUSY;
	if (!mutex_trylock(&dev->empress_tsq.vb_lock))
		goto done;
	if (dev->empress_users)                 <-------------
		goto done_up;

	/* Unmute audio */
	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
		saa_readb(SAA7134_AUDIO_MUTE_CTRL) & ~(1 << 6));

	dev->empress_users++;    <------ this should be "dev->empress_users = 1;"
	file->private_data = dev;
	err = 0;

done_up:
	mutex_unlock(&dev->empress_tsq.vb_lock);
done:
	return err;
}

static int ts_release(struct inode *inode, struct file *file)
{
	(...)
	dev->empress_users--;   <------------ this should be "dev->empress_users = 0;"
	return 0;
}
