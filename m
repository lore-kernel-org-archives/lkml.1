Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbZDYFfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbZDYFfb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 01:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZDYFfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 01:35:21 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51682 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZDYFfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 01:35:19 -0400
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090425012020.457460929@suse.de>
	<20090425012209.061706790@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 24 Apr 2009 22:35:10 -0700
In-Reply-To: <20090425012209.061706790@suse.de> (npiggin@suse.de's message of "Sat\, 25 Apr 2009 11\:20\:21 +1000")
Message-ID: <m163gtz46p.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: npiggin@suse.de, alan@lxorguk.ukuu.org.uk, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;npiggin@suse.de
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0050]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [patch 01/27] fs: cleanup files_lock
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

npiggin@suse.de writes:

> Lock tty_files with tty_mutex, provide helpers to manipulate the per-sb
> files list, and unexport the files_lock spinlock.

This conflicts a bit with some of my ongoing work, which is generalizing
the file list to make it more useful and makes the tty case much less
of a special case.

Do you know if the performance improvement would be anywhere near as good if
file_list and file_list_lock becoming per inode?

Do you have any idea what the performance improvement with changing the file_list_lock
is?


> Index: linux-2.6/fs/open.c
> ===================================================================
> --- linux-2.6.orig/fs/open.c
> +++ linux-2.6/fs/open.c
> @@ -828,7 +828,7 @@ static struct file *__dentry_open(struct
>  	f->f_path.mnt = mnt;
>  	f->f_pos = 0;
>  	f->f_op = fops_get(inode->i_fop);
> -	file_move(f, &inode->i_sb->s_files);
> +	file_sb_list_add(f, inode->i_sb);

You can make this just:
	 if (!special_file(inode->i_mode))
		file_add(f, &inode->i_files);

And save yourself a lot of complexity.

Eric
