Return-Path: <linux-kernel-owner+w=401wt.eu-S933227AbYEFWH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227AbYEFWH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758025AbYEFWHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:07:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:61366 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYEFWHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:07:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kbYr+rO+4zjNMwkUVIGJ7yqnIDky8MDS3BdY70RM02yQrpMm4K88pCxPbOciAEF43tjaOU/RqPLQvkbWxL8w/ozj1wL2/CYEvRf32WIMcC26KWNvwc3nuHMRTDLp+0w/iunl5Wk/i4Doa1irtGZA89ppSodfK009Ip95T5EYzH4=
Message-ID: <524f69650805061507h5dab8731odeadb7602e0f38e4@mail.gmail.com>
Date: Tue, 6 May 2008 17:07:44 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [patch 2/2] cifs - cifs_find_tcp_session cleanup
Cc: "Steve French" <sfrench@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4819e79f.0c07560a.5b13.ffff8e6c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080501154830.235254575@gmail.com>
	 <4819e79f.0c07560a.5b13.ffff8e6c@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like it would fail in the ipv6 case - because
target_ip_addr (the ipv4 address) would be null and it would exit
before checking.



On Thu, May 1, 2008 at 10:48 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> This patch is to remove too indented code in cifs_find_tcp_session.
>  Also memcmp was used wrongly - we would have found the session
>  which IP6 addresses didn't match.
>
>  Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>  ---
>
>  Index: linux-2.6.git/fs/cifs/connect.c
>  ===================================================================
>  --- linux-2.6.git.orig/fs/cifs/connect.c        2008-05-01 19:02:51.000000000 +0400
>  +++ linux-2.6.git/fs/cifs/connect.c     2008-05-01 19:36:54.000000000 +0400
>  @@ -1318,42 +1318,44 @@ cifs_parse_mount_options(char *options,
>
>   static struct cifsSesInfo *
>   cifs_find_tcp_session(struct in_addr *target_ip_addr,
>  -               struct in6_addr *target_ip6_addr,
>  -                char *userName, struct TCP_Server_Info **psrvTcp)
>  +                     struct in6_addr *target_ip6_addr,
>  +                     char *userName, struct TCP_Server_Info **psrvTcp)
>   {
>         struct list_head *tmp;
>         struct cifsSesInfo *ses;
>  +
>         *psrvTcp = NULL;
>  -       read_lock(&GlobalSMBSeslock);
>
>  +       if (!target_ip_addr)
>  +               return NULL;
>  +
>  +       read_lock(&GlobalSMBSeslock);
>         list_for_each(tmp, &GlobalSMBSessionList) {
>                 ses = list_entry(tmp, struct cifsSesInfo, cifsSessionList);
>  -               if (ses->server) {
>  -                       if ((target_ip_addr &&
>  -                               (ses->server->addr.sockAddr.sin_addr.s_addr
>  -                                 == target_ip_addr->s_addr)) || (target_ip6_addr
>  -                               && memcmp(&ses->server->addr.sockAddr6.sin6_addr,
>  -                                       target_ip6_addr, sizeof(*target_ip6_addr)))) {
>  -                               /* BB lock server and tcp session and increment
>  -                                     use count here?? */
>  -
>  -                               /* found a match on the TCP session */
>  -                               *psrvTcp = ses->server;
>  -
>  -                               /* BB check if reconnection needed */
>  -                               if (strncmp
>  -                                   (ses->userName, userName,
>  -                                    MAX_USERNAME_SIZE) == 0){
>  -                                       read_unlock(&GlobalSMBSeslock);
>  -                                       /* Found exact match on both TCP and
>  -                                          SMB sessions */
>  -                                       return ses;
>  -                               }
>  -                       }
>  -               }
>  -               /* else tcp and smb sessions need reconnection */
>  +               if (!ses->server)
>  +                       continue;
>  +
>  +               if (ses->server->addr.sockAddr.sin_addr.s_addr != target_ip_addr->s_addr ||
>  +                   memcmp(&ses->server->addr.sockAddr6.sin6_addr,
>  +                          target_ip6_addr, sizeof(*target_ip6_addr)))
>  +                       continue;
>  +
>  +               /* BB lock server and tcp session and increment
>  +                  use count here?? */
>  +
>  +               /* found a match on the TCP session */
>  +               *psrvTcp = ses->server;
>  +
>  +               /* BB check if reconnection needed */
>  +               if (strncmp(ses->userName, userName, MAX_USERNAME_SIZE))
>  +                       continue;
>  +
>  +               /* Found exact match on both TCP and SMB sessions */
>  +               read_unlock(&GlobalSMBSeslock);
>  +               return ses;
>         }
>         read_unlock(&GlobalSMBSeslock);
>  +
>         return NULL;
>   }
>
>
>  --
>



-- 
Thanks,

Steve
