Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbZDXHNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbZDXHNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbZDXHNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:13:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34519 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446AbZDXHNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:13:17 -0400
Date: Fri, 24 Apr 2009 08:13:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
Message-ID: <20090424071312.GE8633@ZenIV.linux.org.uk>
References: <20090423191934.GW1926@parisc-linux.org> <1240556813-8739-1-git-send-email-abogani@texware.it> <1240556813-8739-2-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240556813-8739-2-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 09:06:53AM +0200, Alessio Igor Bogani wrote:
>  static void cifs_umount_begin(struct super_block *sb)
>  {
> -	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
> +	struct cifs_sb_info *cifs_sb;
>  	struct cifsTconInfo *tcon;
>  
> -	if (cifs_sb == NULL)
> +	lock_kernel();
> +	cifs_sb = CIFS_SB(sb);
> +
> +	if (cifs_sb == NULL) {
> +		unlock_kernel();
>  		return;
> +	}
>  
>  	tcon = cifs_sb->tcon;
> -	if (tcon == NULL)
> +	if (tcon == NULL) {
> +		unlock_kernel();
>  		return;
> +	}

AFAICS, both CIFS_SB(sb) and ->tcon are assign-once, so lock_kernel() should
really go here (if it can't be removed completely, of course, but that's up
to CIFS folks).  Applied with such modification.
