Return-Path: <linux-kernel-owner+w=401wt.eu-S1752981AbZHMFGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbZHMFGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 01:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZHMFGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 01:06:31 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:49795 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZHMFGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 01:06:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kzKZ89PvWZVcAEZZpnqPS16oOtQ/rB6DP2btyDQZJ9O1tPAVxzba3+WrsDNV+IqwJh
         c060vEzL8hK1KvGpp+03i6K5VWhVexUtP/OgG42XnNak9NLz0hVsr8nPiTTwrhoNkifK
         TY7FbRWBBiFHLib47eVCSLy3IMbzMunf6kXBs=
Date: Thu, 13 Aug 2009 13:08:45 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/5] arch/um: handle compat_ioctl in tty line driver
Message-ID: <20090813050845.GD5031@cr0.nay.redhat.com>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de> <1249564170-18627-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249564170-18627-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 03:09:26PM +0200, Arnd Bergmann wrote:
>This pushes the handling of VT specific ioctls down to the
>UML specific drivers so we can remove it from the common
>compat_ioctl.c file.
>
>Cc: Jeff Dike <jdike@addtoit.com>
>Signed-off-by: Arnd Bergmann <arnd@arndb.de>


Acked-by: WANG Cong <xiyou.wangcong@gmail.com>



>---
> arch/um/drivers/line.c          |    6 ++++++
> arch/um/drivers/ssl.c           |    1 +
> arch/um/drivers/stdio_console.c |    1 +
> arch/um/include/shared/line.h   |    2 ++
> 4 files changed, 10 insertions(+), 0 deletions(-)
>
>diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
>index 14a102e..9819a3b 100644
>--- a/arch/um/drivers/line.c
>+++ b/arch/um/drivers/line.c
>@@ -314,6 +314,12 @@ int line_ioctl(struct tty_struct *tty, struct file * file,
> 	return ret;
> }
> 
>+long line_compat_ioctl(struct tty_struct *tty, struct file * file,
>+	       unsigned int cmd, unsigned long arg)
>+{
>+	return line_ioctl(tty, file, cmd, arg);
>+}
>+
> void line_throttle(struct tty_struct *tty)
> {
> 	struct line *line = tty->driver_data;
>diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
>index f1786e6..eccf14a 100644
>--- a/arch/um/drivers/ssl.c
>+++ b/arch/um/drivers/ssl.c
>@@ -137,6 +137,7 @@ static const struct tty_operations ssl_ops = {
> 	.flush_chars 		= line_flush_chars,
> 	.set_termios 		= line_set_termios,
> 	.ioctl 	 		= line_ioctl,
>+	.compat_ioctl 	 	= line_compat_ioctl,
> 	.throttle 		= line_throttle,
> 	.unthrottle 		= line_unthrottle,
> #if 0
>diff --git a/arch/um/drivers/stdio_console.c b/arch/um/drivers/stdio_console.c
>index 49266f6..2cb1f04 100644
>--- a/arch/um/drivers/stdio_console.c
>+++ b/arch/um/drivers/stdio_console.c
>@@ -120,6 +120,7 @@ static const struct tty_operations console_ops = {
> 	.flush_chars 		= line_flush_chars,
> 	.set_termios 		= line_set_termios,
> 	.ioctl 	 		= line_ioctl,
>+	.compat_ioctl 	 	= line_compat_ioctl,
> 	.throttle 		= line_throttle,
> 	.unthrottle 		= line_unthrottle,
> };
>diff --git a/arch/um/include/shared/line.h b/arch/um/include/shared/line.h
>index 311a0d3..6ef62e4 100644
>--- a/arch/um/include/shared/line.h
>+++ b/arch/um/include/shared/line.h
>@@ -79,6 +79,8 @@ extern void line_flush_chars(struct tty_struct *tty);
> extern int line_write_room(struct tty_struct *tty);
> extern int line_ioctl(struct tty_struct *tty, struct file * file,
> 		      unsigned int cmd, unsigned long arg);
>+extern long line_compat_ioctl(struct tty_struct *tty, struct file * file,
>+		      unsigned int cmd, unsigned long arg);
> extern void line_throttle(struct tty_struct *tty);
> extern void line_unthrottle(struct tty_struct *tty);
> 
>-- 
>1.6.3.3
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
