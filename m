Return-Path: <linux-kernel-owner+w=401wt.eu-S933132AbYEFWGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbYEFWGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYEFWGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:06:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:51360 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164AbYEFWGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hjq4jNiVmwNVYQHrhhSC8Y9QPGTnoumD5gcEclTqQARmyxaFLNlRoX7c88g/UgIIV7SB49TduUtvbPkdzzFPIC+f4ZKBURrqtc/lFFeYCK1TU5OBEhaJFn/B/eGfxdHjCbMT8iLX2GqIIT85BxoMl9LEcATHQ+G5bJaQzJDeVfU=
Message-ID: <524f69650805061506g55bdf6b0w7d5b936b7ec8bad4@mail.gmail.com>
Date: Tue, 6 May 2008 17:06:26 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [patch 1/2] cifs - find_unc cleanup
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4819e79f.0c58560a.0f2c.ffff9899@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080501154830.235254575@gmail.com>
	 <4819e79f.0c58560a.0f2c.ffff9899@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged

On Thu, May 1, 2008 at 10:48 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> This patch is to remove too indented code in find_unc
>
>  Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>  ---
>
>  Index: linux-2.6.git/fs/cifs/connect.c
>  ===================================================================
>  --- linux-2.6.git.orig/fs/cifs/connect.c        2008-05-01 18:21:38.000000000 +0400
>  +++ linux-2.6.git/fs/cifs/connect.c     2008-05-01 19:02:51.000000000 +0400
>  @@ -1362,45 +1362,43 @@ find_unc(__be32 new_target_ip_addr, char
>   {
>         struct list_head *tmp;
>         struct cifsTconInfo *tcon;
>  +       __be32 old_ip;
>
>         read_lock(&GlobalSMBSeslock);
>  +
>         list_for_each(tmp, &GlobalTreeConnectionList) {
>                 cFYI(1, ("Next tcon"));
>                 tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
>  -               if (tcon->ses) {
>  -                       if (tcon->ses->server) {
>  -                               cFYI(1,
>  -                                    ("old ip addr: %x == new ip %x ?",
>  -                                     tcon->ses->server->addr.sockAddr.sin_addr.
>  -                                     s_addr, new_target_ip_addr));
>  -                               if (tcon->ses->server->addr.sockAddr.sin_addr.
>  -                                   s_addr == new_target_ip_addr) {
>  -       /* BB lock tcon, server and tcp session and increment use count here? */
>  -                                       /* found a match on the TCP session */
>  -                                       /* BB check if reconnection needed */
>  -                                       cFYI(1,
>  -                                             ("IP match, old UNC: %s new: %s",
>  -                                             tcon->treeName, uncName));
>  -                                       if (strncmp
>  -                                           (tcon->treeName, uncName,
>  -                                            MAX_TREE_SIZE) == 0) {
>  -                                               cFYI(1,
>  -                                                    ("and old usr: %s new: %s",
>  -                                                     tcon->treeName, uncName));
>  -                                               if (strncmp
>  -                                                   (tcon->ses->userName,
>  -                                                    userName,
>  -                                                    MAX_USERNAME_SIZE) == 0) {
>  -                                                       read_unlock(&GlobalSMBSeslock);
>  -                                                       /* matched smb session
>  -                                                       (user name */
>  -                                                       return tcon;
>  -                                               }
>  -                                       }
>  -                               }
>  -                       }
>  -               }
>  +               if (!tcon->ses || !tcon->ses->server)
>  +                       continue;
>  +
>  +               old_ip = tcon->ses->server->addr.sockAddr.sin_addr.s_addr;
>  +               cFYI(1, ("old ip addr: %x == new ip %x ?",
>  +                       old_ip, new_target_ip_addr));
>  +
>  +               if (old_ip != new_target_ip_addr)
>  +                       continue;
>  +
>  +               /* BB lock tcon, server and tcp session and increment use count here? */
>  +               /* found a match on the TCP session */
>  +               /* BB check if reconnection needed */
>  +               cFYI(1, ("IP match, old UNC: %s new: %s",
>  +                       tcon->treeName, uncName));
>  +
>  +               if (strncmp(tcon->treeName, uncName, MAX_TREE_SIZE))
>  +                       continue;
>  +
>  +               cFYI(1, ("and old usr: %s new: %s",
>  +                       tcon->treeName, uncName));
>  +
>  +               if (strncmp(tcon->ses->userName, userName, MAX_USERNAME_SIZE))
>  +                       continue;
>  +
>  +               /* matched smb session (user name) */
>  +               read_unlock(&GlobalSMBSeslock);
>  +               return tcon;
>         }
>  +
>         read_unlock(&GlobalSMBSeslock);
>         return NULL;
>   }
>
>  --
>



-- 
Thanks,

Steve
