Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYJGRzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYJGRzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYJGRze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:55:34 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:41628 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYJGRzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:55:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=f5FI2VkYXdIKPQL27K99YyJG1BHnAOYNVxNLrxVfHbKrtr5cf5MaQLe+beTKKRyHAE
         waxNFE9Tzjib6U0QRdz0k5hmUNbrhK8GGDC2Sau+CFBSggNm5JHAMOLqwSJuvBhmrWKQ
         hOYjRRk7Mw0ktE8q7Ih4uo3zUOrkkt0EbOgAo=
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Message-Id: <786804A2-4288-46F5-82B8-3FF9B6FD196C@gmail.com>
From: Richard Holden <aciddeath@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20081007173515.1c161dce@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: BKL still required for what functions?
Date: Tue, 7 Oct 2008 11:55:27 -0600
References: <F99FEC4F-DEDD-4E55-93B4-A0761F30E1A2@gmail.com> <20081007173515.1c161dce@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7, 2008, at 10:35 AM, Alan Cox wrote:
>
> Its never so simple - a lot of the functions it depends what data  
> you are
> using or passing to them whether they are BKL safe.
>
> Which bits use the BKL and what do you need to know is safe ?

Actually, it looks like I was looking at 2 different places, the  
simple removal is in phonedev.c that you authored, as far as I can  
tell the only thing the BKL is protecting is a call to request_module,  
it may be some nesting rules that I don't understand but I think if it  
is still needed there we could push the lock_kernel call down to the  
site of the request_module call. See patch below.

Thanks,
Richard Holden

Signed-off-by: Richard Holden <aciddeath@gmail.com>

diff --git a/drivers/telephony/phonedev.c b/drivers/telephony/phonedev.c
index 4d74ba3..fd1424c 100644
--- a/drivers/telephony/phonedev.c
+++ b/drivers/telephony/phonedev.c
@@ -54,14 +54,16 @@ static int phone_open(struct inode *inode, struct  
file *file)
  	if (minor >= PHONE_NUM_DEVICES)
  		return -ENODEV;

-	lock_kernel();
+	
  	mutex_lock(&phone_lock);
  	p = phone_device[minor];
  	if (p)
  		new_fops = fops_get(p->f_op);
  	if (!new_fops) {
  		mutex_unlock(&phone_lock);
+		lock_kernel();
  		request_module("char-major-%d-%d", PHONE_MAJOR, minor);
+		unlock_kernel();
  		mutex_lock(&phone_lock);
  		p = phone_device[minor];
  		if (p == NULL || (new_fops = fops_get(p->f_op)) == NULL)
@@ -81,7 +83,6 @@ static int phone_open(struct inode *inode, struct  
file *file)
  	fops_put(old_fops);
  end:
  	mutex_unlock(&phone_lock);
-	unlock_kernel();
  	return err;
  }


