Return-Path: <linux-kernel-owner+w=401wt.eu-S1762929AbXJNR4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929AbXJNR4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbXJNR4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:56:41 -0400
Received: from web36603.mail.mud.yahoo.com ([209.191.85.20]:23148 "HELO
	web36603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753904AbXJNR4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:56:40 -0400
X-YMail-OSG: RzxLZi0VM1m0bZG8Az4e5k.SaKtYQBhU9vF35C3jGwtqG3CG0BV8FVPVZ2SiG_QIVindEcZUMQ--
X-RocketYMMF: rancidfat
Date: Sun, 14 Oct 2007 10:56:39 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 7 (2.6.23) Smack: Simplified Mandatory Access Control Kernel
To: Al Viro <viro@ftp.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071014173439.GV8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <211767.79952.qm@web36603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Al Viro <viro@ftp.linux.org.uk> wrote:

> On Sun, Oct 14, 2007 at 10:15:42AM -0700, Casey Schaufler wrote:
> > This version fixes a major blunder in label handling. The system
> > works, but has a serious memory leak that also induces a gradual
> > performance degradation. Al Viro gets the credit for pointing out
> > that one. Al suggested several other improvements that are not
> > included. They should come soon, but I wanted to get this flaw
> > out of the code before too many people hit it.
> 
> Ahem... This
> 
> > +static ssize_t smk_write_doi(struct file *file, const char __user *buf,
> > +			     size_t count, loff_t *ppos)
> > +{
> > +	char temp[80];
> > +	int i;
> > +
> > +	if (!capable(CAP_MAC_OVERRIDE))
> > +		return -EPERM;
> > +
> > +	if (count > sizeof(temp))
> > +		return -EINVAL;
> > +
> > +	if (copy_from_user(temp, buf, count) != 0)
> > +		return -EFAULT;
> > +
> > +	if (sscanf(temp, "%d", &i) != 1)
> > +		return -EINVAL;
> 
> is not really a missing improvement; it's a geniune undefined behaviour.
> temp[] is uninitialized, then you copy there some data that doesn't have
> to contain NUL, then you call sscanf().  Boom.  The same goes for the rest
> of similar places.
> 
> And this
> 
> > +static ssize_t smk_read_ambient(struct file *filp, char __user *buf,
> > +				size_t cn, loff_t *ppos)
> > +{
> > +	ssize_t rc;
> > +	int asize = strlen(smack_net_ambient) + 1;
> > +
> > +	if (cn < asize)
> > +		return -EINVAL;
> > +
> > +	if (*ppos != 0)
> > +		return 0;
> > +
> > +	rc = simple_read_from_buffer(buf, cn, ppos, smack_net_ambient, asize);
> 
> is honest-to-$DEITY security hole - that file is world-readable and there's
> nothing to prevent simple_read_from_buffer() blocking on page-in of buf,
> then root writing to that file changing smack_net_ambient and doing kfree()
> on the old value - one we'd already passed to simple_read_from_buffer().
> At which point reader is about to get whatever data that might land in
> whatever that memory gets reused for.
> 
> Besides, as I said the last time, smack_net_ambient has every right to
> get changed between strlen() and passing argument to
> simple_read_from_buffer(),
> in which case you'll be copying the amount of data that used to be in the
> old one, taking it from the new one.  New one might very well be shorter.

Yep. I got work to do. I know it ain't getting done today, and I know
that the change I put out is affecting people, so I decided not to
wait until I'd done the whole lot.

Sorry if it sounded as if I wasn't taking the comments seriously.
I am. Thank you again.


Casey Schaufler
casey@schaufler-ca.com
