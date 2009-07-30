Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZG3B2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZG3B2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 21:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZG3B2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 21:28:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33567 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbZG3B2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 21:28:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Fb4fSlOUt/6ndbpuVBCjgVE3tBAkVGO5xGfpU2Q09PIgy3Uf8lK8XYEpTjM54WRVm
	j9dBbTkab8qkO+ifl9Lcw==
MIME-Version: 1.0
In-Reply-To: <33307c790907291719r2caf7914xb543877464ba6fc2@mail.gmail.com>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com>
	 <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com>
	 <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com>
	 <20090729114322.GA9335@localhost>
	 <33307c790907291719r2caf7914xb543877464ba6fc2@mail.gmail.com>
Date: Wed, 29 Jul 2009 18:28:07 -0700
Message-ID: <33307c790907291828x6906e874l4d75e695116aa874@mail.gmail.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
From: Martin Bligh <mbligh@google.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Michael Rubin <mrubin@google.com>,
       Andrew Morton <akpm@google.com>, sandeen@redhat.com,
       Michael Davidson <md@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 5:19 PM, Martin Bligh<mbligh@google.com> wrote:
> BTW, can you explain this code at the bottom of generic_sync_sb_inodes
> for me?
>
>                if (wbc->nr_to_write <= 0) {
>                        wbc->more_io = 1;
>                        break;
>                }
>
> I don't understand why we are setting more_io here? AFAICS, more_io
> means there's more stuff to write ... I would think we'd set this if
> nr_to_write was > 0 ?
>
> Or just have the section below brought up above this
> break check and do:
>
> if (!list_empty(&sb->s_more_io) || !list_empty(&sb->s_io))
>        wbc->more_io = 1;
>
> Am I just misunderstanding the intent of more_io ?

I am thinking along the lines of:

@@ -638,13 +609,11 @@ sync_sb_inodes(struct super_block *sb, s
                iput(inode);
                cond_resched();
                spin_lock(&inode_lock);
-               if (wbc->nr_to_write <= 0) {
-                       wbc->more_io = 1;
+               if (wbc->nr_to_write <= 0)
                        break;
-               }
-               if (!list_empty(&sb->s_more_io))
-                       wbc->more_io = 1;
        }
+       if (!list_empty(&sb->s_more_io) || !list_empty(&sb->s_io)
+               wbc->more_io = 1;
        return;         /* Leave any unwritten inodes on s_io */
 }
