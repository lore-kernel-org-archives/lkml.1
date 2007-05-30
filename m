Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbXE3Ldk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbXE3Ldk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXE3Ldd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:33:33 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:11366 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXE3Ldc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:33:32 -0400
Date: Wed, 30 May 2007 13:33:29 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, dmitry.torokhov@gmail.com, oneukum@suse.de,
       rpurdie@rpsys.net, stern@rowland.harvard.edu, maneesh@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] sysfs: use sysfs_lock to protect the sysfs_dirent
 tree
Message-ID: <20070530133329.4a10a892@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1180370187803-git-send-email-htejun@gmail.com>
References: <11803701861778-git-send-email-htejun@gmail.com>
	<1180370187803-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 01:36:27 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> @@ -795,6 +822,8 @@ static int sysfs_readdir(struct file * f
>  			i++;
>  			/* fallthrough */
>  		default:
> +			spin_lock(&sysfs_lock);
> +
>  			pos = &parent_sd->s_children;
>  			while (*pos != cursor)
>  				pos = &(*pos)->s_sibling;
> @@ -827,6 +856,8 @@ static int sysfs_readdir(struct file * f
>  			/* put cursor back in */
>  			cursor->s_sibling = *pos;
>  			*pos = cursor;
> +
> +			spin_unlock(&sysfs_lock);
>  	}
>  	return 0;
>  }

Here's the cause of the "sleeping function called" I saw. filldir() is
called under sysfs_lock, but calls copy_to_user()... This means you
can't use sysfs_lock for protection here.
