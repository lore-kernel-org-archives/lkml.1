Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbZLOOju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbZLOOju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZLOOjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:39:46 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:52722 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZLOOjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:39:45 -0500
Subject: Re: get_sb_single() - do not pass options twice
From: Kay Sievers <kay.sievers@vrfy.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       greg@kroah.com
In-Reply-To: <E1NKU1C-0005jr-P8@pomaz-ex.szeredi.hu>
References: <1257460103.2126.0.camel@yio.site>
	 <ac3eb2510912120207r528229f6uf8bd0535a6ce76a@mail.gmail.com>
	 <E1NKU1C-0005jr-P8@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 15:39:21 +0100
Message-Id: <1260887961.2161.6.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 10:48 +0100, Miklos Szeredi wrote:
> On Sat, 12 Dec 2009, Kay Sievers wrote:
> > Ping! Can someone please have a look and comment on that?
> > Something like this will now be needed for 2.6.33 to silent a warning.

> > > --- a/fs/super.c
> > > +++ b/fs/super.c
> > > @@ -900,6 +900,8 @@ int get_sb_single(struct file_system_typ
> > >                        deactivate_locked_super(s);
> > >                        return error;
> > >                }
> > > +               /* options usually get mangled and can only be parsed once */
> > > +               data = NULL;
> > >                s->s_flags |= MS_ACTIVE;
> > >        }
> > >        do_remount_sb(s, flags, data, 0);
> 
> I think the do_remount_sb() is a NOP in that case.  So shouldn't it
> rather be
> 
> 	} else {
> 		do_remount_sb(s, flags, data, 0);
> 	}

Yeah, sounds good to me. I wasn't sure if this was done for some
non-obvious reason. In case we can do it this way, here is the patch.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: vfs: get_sb_single() - do not pass options twice

Filesystem code usually destroys the option buffer while
parsing it. This leads to errors when the same buffer is
passed twice. In case we fill a new superblock do not call
remount.

Cc: Greg KH <greg@kroah.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 fs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -901,8 +901,9 @@ int get_sb_single(struct file_system_typ
 			return error;
 		}
 		s->s_flags |= MS_ACTIVE;
+	} else {
+		do_remount_sb(s, flags, data, 0);
 	}
-	do_remount_sb(s, flags, data, 0);
 	simple_set_mnt(mnt, s);
 	return 0;
 }


