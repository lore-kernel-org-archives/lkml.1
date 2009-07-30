Return-Path: <linux-kernel-owner+w=401wt.eu-S1751559AbZG3CJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbZG3CJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 22:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZG3CJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 22:09:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:30589 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZG3CJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 22:09:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,291,1246863600"; 
   d="scan'208";a="170384629"
Date: Thu, 30 Jul 2009 10:09:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Martin Bligh <mbligh@google.com>
Cc: Chad Talbott <ctalbott@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       "sandeen@redhat.com" <sandeen@redhat.com>,
       Michael Davidson <md@google.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
Message-ID: <20090730020922.GD7326@localhost>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com> <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com> <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com> <20090729114322.GA9335@localhost> <33307c790907291719r2caf7914xb543877464ba6fc2@mail.gmail.com> <33307c790907291828x6906e874l4d75e695116aa874@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <33307c790907291828x6906e874l4d75e695116aa874@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 09:28:07AM +0800, Martin Bligh wrote:
> On Wed, Jul 29, 2009 at 5:19 PM, Martin Bligh<mbligh@google.com> wrote:
> > BTW, can you explain this code at the bottom of generic_sync_sb_inodes
> > for me?
> >
> >                if (wbc->nr_to_write <= 0) {
> >                        wbc->more_io = 1;
> >                        break;
> >                }
> >
> > I don't understand why we are setting more_io here? AFAICS, more_io
> > means there's more stuff to write ... I would think we'd set this if
> > nr_to_write was > 0 ?
> >
> > Or just have the section below brought up above this
> > break check and do:
> >
> > if (!list_empty(&sb->s_more_io) || !list_empty(&sb->s_io))
> >        wbc->more_io = 1;
> >
> > Am I just misunderstanding the intent of more_io ?
> 
> I am thinking along the lines of:

On closer looks I found this line:

                if (inode_dirtied_after(inode, start))
                        break;

In this case "list_empty(&sb->s_io)" is not a good criteria:
here we are breaking away for some other reasons, and shall
not touch wbc.more_io.

So let's stick with the current code?

Thanks,
Fengguang

> @@ -638,13 +609,11 @@ sync_sb_inodes(struct super_block *sb, s
>                 iput(inode);
>                 cond_resched();
>                 spin_lock(&inode_lock);
> -               if (wbc->nr_to_write <= 0) {
> -                       wbc->more_io = 1;
> +               if (wbc->nr_to_write <= 0)
>                         break;
> -               }
> -               if (!list_empty(&sb->s_more_io))
> -                       wbc->more_io = 1;
>         }
> +       if (!list_empty(&sb->s_more_io) || !list_empty(&sb->s_io)
> +               wbc->more_io = 1;
>         return;         /* Leave any unwritten inodes on s_io */
>  }
