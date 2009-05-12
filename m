Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbZELOEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbZELOEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZELOD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:03:58 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42050 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbZELOD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:03:58 -0400
From: Arnd Bergmann <ARNDB@de.ibm.com>
Organization: IBM Deutschland Research & Development GmbH, Vorsitzender des Aufsichtsrats: Johann Weihen, Geschaeftssfuehrung: Erich Baier, Sitz der Gesellschaft: Boeblingen, Registergericht: Amtsgericht Stuttgart, HRB 243294
To: jblunck@suse.de
Subject: Re: [patch 1/2] spufs: make dentry reference count and locking symmetric
Date: Tue, 12 May 2009 16:03:49 +0200
User-Agent: KMail/1.9.9
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
References: <20090505213203.797397821@suse.de> <20090505214433.946117208@suse.de>
In-Reply-To: <20090505214433.946117208@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905121603.50251.ARNDB@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 May 2009, jblunck@suse.de wrote:
> @@ -505,10 +505,7 @@ spufs_create_context(struct inode *inode
>  out_aff_unlock:
>         if (affinity)
>                 mutex_unlock(&gang->aff_mutex);
> -out_unlock:
> -       mutex_unlock(&inode->i_mutex);
>  out:
> -       dput(dentry);
>         return ret;
>  }
>  

There is a nasty deadlock problem with spu_forget(), which we
must call after unlocking i_mutex but before the final dput, IIRC.

The path down there is something like 

spu_forget -> mmput -> exit_mmap -> remove_vma -> 
	fput -> dput -> dentry_iput -> iput -> iput_final ->
	spufs_delete_inode -> destroy_spu_context.

	Arnd <><
