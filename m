Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYACOLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYACOLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYACOLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:11:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36071 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbYACOLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:11:30 -0500
Date: Thu, 3 Jan 2008 15:11:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Jiri Slaby <jirislaby@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
Message-ID: <20080103141120.GC19363@elte.hu>
References: <477CE1E0.4010504@gmail.com> <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

>  			return ERR_PTR(-EACCES);
>  		}
> +		if (is_bad_inode(inode)) {
> +			unlock_kernel();
> +			iput(inode);
> +			return ERR_PTR(-ENOENT);
> +		}

fs/isofs/rock.c:474 parse_rock_ridge_inode_internal() seems buggy too:

                        reloc =
                            isofs_iget(inode->i_sb,
                                       ISOFS_I(inode)->i_first_extent,
                                       0);
                        if (!reloc)
                                goto out;

it should probably do "!reloc || is_bad_inode(inode)" as well.

and there are about 5 other callsites as well that only check for a NULL 
return.

perhaps the better fix would be to add this to inode.c:isofs_iget():

        if (inode && (inode->i_state & I_NEW)) {
                sb->s_op->read_inode(inode);
                unlock_new_inode(inode);
                if (s_bad_inode(inode))
			inode = NULL;
        }

?

	Ingo
