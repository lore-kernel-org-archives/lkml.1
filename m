Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbZBYRVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbZBYRVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 12:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZBYRVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 12:21:44 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:35918 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZBYRVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 12:21:42 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: etienne <etienne.basset@numericable.fr>
Subject: Re: [PATCH][SMACK] add a socket_post_accept hook to fix netlabel issues with labeled TCP servers V1
Date: Wed, 25 Feb 2009 12:21:35 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.27-gentoo-r8; KDE/4.2.0; i686; ; )
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM <linux-security-module@vger.kernel.org>
References: <fa.eUdEnVYPYgnfwD9aw1dVY6gL1+E@ifi.uio.no> <49A47BEF.5030507@numericable.fr> <200902241836.59679.paul.moore@hp.com>
In-Reply-To: <200902241836.59679.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902251221.36081.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009 06:36:59 pm Paul Moore wrote:
> On Tuesday 24 February 2009 05:59:59 pm etienne wrote:
> > Paul Moore wrote:
> > > On Tuesday 24 February 2009 05:20:42 pm etienne wrote:
> > >> Paul Moore wrote:
> > >>> On Tuesday 24 February 2009 04:28:24 pm etienne wrote:
> > >>>>  /**
> > >>>> + * smack_socket_post_access - post access check
> > >>>> + * @sock: the socket
> > >>>> + * @newsock : the grafted sock
> > >>>> + *
> > >>>> + * we have to match client IP against smack_host_label()
> > >>>> + */
> > >>>> +static void  smack_socket_post_accept(struct socket *sock, struct
> > >>>> socket *newsock) +{
> > >>>> +	char *hostsp;
> > >>>> +	struct sockaddr_storage address;
> > >>>> +	struct sockaddr_in *sin;
> > >>>> +	struct sockaddr_in6 *sin6;
> > >>>> +	struct in6_addr *addr6;
> > >>>> +	struct socket_smack *ssp = newsock->sk->sk_security;
> > >>>> +	int len;
> > >>>> +
> > >>>> +	if (sock->sk == NULL)
> > >>>> +		return;
> > >>>> +
> > >>>> +	/* sockets can listen on both IPv4 & IPv6,
> > >>>> +	   and fallback to V4 if client is V4 */
> > >>>> +	if  (newsock->sk->sk_family != AF_INET && newsock->sk->sk_family
> > >>>> != AF_INET6) +		return;
> > >>>> +
> > >>>> +	/* get the client IP address **/
> > >>>> +	newsock->ops->getname(newsock, (struct sockaddr *)&address, &len,
> > >>>> 2); +
> > >>>> +	switch (newsock->sk->sk_family) {
> > >>>> +	case AF_INET:
> > >>>> +		sin = (struct sockaddr_in *)&address;
> > >>>> +		break;
> > >>>> +	case AF_INET6:
> > >>>> +		sin6  = (struct sockaddr_in6 *)&address;
> > >>>> +		addr6 = &sin6->sin6_addr;
> > >>>> +		/* if a V4 client connects to a V6 listening server,
> > >>>> +		 * we will get a IPV6_ADDR_MAPPED mapped address here
> > >>>> +		 * we have to handle this case too
> > >>>> +		 * the test below is ipv6_addr_type()== IPV6_ADDR_MAPPED
> > >>>> +		 * without the requirement to have IPv6 compiled in
> > >>>> +		 */
> > >>>> +		if ((addr6->s6_addr32[0] | addr6->s6_addr32[1]) == 0 &&
> > >>>> +				addr6->s6_addr32[2] == htonl(0x0000ffff)) {
> > >>>> +			__be32 addr = sin6->sin6_addr.s6_addr32[3];
> > >>>> +			__be16 port = sin6->sin6_port;
> > >>>> +			sin = (struct sockaddr_in *)&address;
> > >>>> +			sin->sin_family = AF_INET;
> > >>>> +			sin->sin_port = port;
> > >>>> +			sin->sin_addr.s_addr = addr;
> > >>>> +		} else {
> > >>>> +			/* standard IPv6, we'll send unlabeled */
> > >>>> +			smack_netlabel(newsock->sk, SMACK_UNLABELED_SOCKET);
> > >>>> +			return;
> > >>>> +		}
> > >>>> +		break;
> > >>>> +	default:
> > >>>> +		/** not possible to be there **/
> > >>>> +		return;
> > >>>> +	}
> > >>>> +	/* so, is there a label for the source IP **/
> > >>>> +	hostsp = smack_host_label(sin);
> > >>>> +
> > >>>> +	if (hostsp == NULL) {
> > >>>> +		if (ssp->smk_labeled != SMACK_CIPSO_SOCKET)
> > >>>> +			smack_netlabel(newsock->sk, SMACK_CIPSO_SOCKET);
> > >>>> +		return;
> > >>>> +	}
> > >>>> +	if (ssp->smk_labeled != SMACK_UNLABELED_SOCKET)
> > >>>> +		smack_netlabel(newsock->sk, SMACK_UNLABELED_SOCKET);
> > >>>> +	return;
> > >>>> +}
> > >>>
> > >>> NAK, you can't ignore return values like that.
> > >>>
> > >>> I'm sorry I didn't get a chance to respond to your email from this
> > >>> morning, but the problem with the post_accept() hook is that you
> > >>> can't fail in this hook.  There has been a _lot_ of discussion about
> > >>> this over the past couple of years on the LSM list.  You should check
> > >>> the archives for all the details but the main problem is that the
> > >>> post_accept() hook is too late to deny the incoming connection so you
> > >>> can't reject the connection at that point in any sane manner.
> > >>
> > >> well, i don't want to reject the connection here :)
> > >>
> > >>> I think I'm going to draft a patch to remove the post_accept()
> > >>> hook since no one in-tree is using it and it's existence seems to
> > >>> cause more problems than it solves.
> > >>>
> > >>> Now, I understand that your patch doesn't actually enforce any access
> > >>> controls but it does call smack_netlabel() in several places and that
> > >>> function can fail
> > >>
> > >> The smack_netlabel(newsock->sk, SMACK_CIPSO_SOCKET) can failed, but
> > >> has no interest in this function (because the socket has already be
> > >> SMACK_CIPSO_SOCKET labeled by the policy) I can remove it.
> > >>
> > >> but smack_netlabel(SMACK_UNLABELED_SOCKET) cannot fail, and that's
> > >> what i'm interested in could this make the patch acceptable?
> > >
> > > Please elaborate a bit more on how you would intend a user to configure
> > > and make use of this.  Also, in what cases would you remove the
> > > NetLabel from a socket?  What cases would you keep it?
> >
> > well, i think it is simple : let's say i want to run a "smack-labelled
> > server" (apache, vsftpd, ...) clients connect from internet,  so the
> > server admin/user  will want to add a "0.0.0.0/0 @" entry in netlabel
> > that will _fail_ because the server will send back "labeled" packets.
>
> I had to go back and look at the address based labeling patches, I had
> somehow forgotten that the single label support in Smack can only be used
> for removing labels, not adding them.  With that in mind your approach
> should work although you will still get really bizarre behavior in the
> following case:
>
>  * Service not running at the ambient label
>  * Only address based label loaded into Smack is "0.0.0.0/0 @" (everything
>    unlabeled)
>  * Client connects to service using labeled networking
>
> If you and Casey can live with labeled connection suddenly becoming
> unlabeled (I doubt the remote host will deal with it very gracefully) then
> go for it.

The more I thought about this last night the more it bothered me so I decided 
to take a quick look to see if I could come up with something that would let 
me sleep easier.  The patch below is likely whitespace mangled and probably 
won't apply cleanly but since I haven't done any testing I consider that a 
good thing.

Take a look at the patch below and see if it accomplishes what you want/need; 
I think this is a much better approach than the socket_post_accept() method.

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0278bc0..6419e83 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -20,6 +20,7 @@
 #include <linux/ext2_fs.h>
 #include <linux/kd.h>
 #include <asm/ioctls.h>
+#include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/mutex.h>
@@ -2559,21 +2560,40 @@ static void smack_sock_graft(struct sock *sk, struct 
socket *parent)
 static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 				   struct request_sock *req)
 {
+	u16 family = sk->sk_family;
 	struct netlbl_lsm_secattr skb_secattr;
 	struct socket_smack *ssp = sk->sk_security;
 	char smack[SMK_LABELLEN];
 	int rc;
 
-	if (skb == NULL)
-		return -EACCES;
+	/* handle mapped IPv4 packets arriving via IPv6 sockets */
+	if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
+		family = PF_INET;
 
 	netlbl_secattr_init(&skb_secattr);
+	
 	rc = netlbl_skbuff_getattr(skb, sk->sk_family, &skb_secattr);
-	if (rc == 0)
+	if (rc == 0) {
+		if (family == PF_INET &&
+		    skb_secattr.type != NETLBL_NLTYPE_UNLABELED) {
+			struct iphdr *hdr = ip_hdr(skb);
+			struct sockaddr_in addr;
+			
+			/* if we are going to treat the other side of this
+			 * connection as a single label, unlabeled host we
+			 * shouldn't allow it to initiate a labeled
+			 * connection because we will end up confusing
+			 * everyone when we suddenly drop the labeling later */
+			addr.sin_addr.s_addr = hdr->saddr;
+			if (smack_host_label(&addr) != NULL) {
+				rc = -EACCES;
+				goto inet_conn_request_return;
+			}
+		}
 		smack_from_secattr(&skb_secattr, smack);
-	else
+	} else
 		strncpy(smack, smack_known_huh.smk_known, SMK_MAXLEN);
-	netlbl_secattr_destroy(&skb_secattr);
+
 	/*
 	 * Receiving a packet requires that the other end
 	 * be able to write here. Read access is not required.
@@ -2585,9 +2605,45 @@ static int smack_inet_conn_request(struct sock *sk, 
 	if (rc == 0)
 		strncpy(ssp->smk_packet, smack, SMK_MAXLEN);
 
+inet_conn_request_return:
+	netlbl_secattr_destroy(&skb_secattr);
 	return rc;
 }
 
+/**
+ * smack_inet_conn_established - Setup a new inbound connection
+ * @sk: the new child socket
+ * @skb: the inbound packet
+ *
+ * Perform the setup of a new inbound stream connection; this basically means
+ * check to see if the other end of the connection is configured as a single
+ * or multi-label host and enure the new connection's socket is configured
+ * correctly.
+ */
+static void smack_inet_conn_established(struct sock *sk, struct sk_buff *skb)
+{
+	struct iphdr *hdr;
+	struct sockaddr_in addr;
+
+	/* we only need to bother with IPv4 since we don't do IPv6 labeling */
+	if (skb->protocol != htons(ETH_P_IP))
+		return;
+
+	hdr = ip_hdr(skb);
+	addr.sin_addr.s_addr = hdr->saddr;
+	if (smack_host_label(&addr) == NULL)
+		return;
+
+	/* the other end of this connection is configured as a single label,
+	 * unlabeled host so we need to make sure we aren't going to label
+	 * the socket */
+	/* NOTE: this is _very_ important - we can only _remove_ the label at
+	 * this point, trying to add a label to the socket here could result
+	 * in a failure which we can't safely catch here due to the inability
+	 * to signal an error */
+	smack_netlabel(sk, SMACK_UNLABELED_SOCKET);
+}
+
 /*
  * Key management security hooks
  *
@@ -2940,6 +2996,7 @@ struct security_operations smack_ops = {
 	.sk_free_security = 		smack_sk_free_security,
 	.sock_graft = 			smack_sock_graft,
 	.inet_conn_request = 		smack_inet_conn_request,
+	.inet_conn_established =	smack_inet_conn_established,
 
  /* key management security hooks */
 #ifdef CONFIG_KEYS

-- 
paul moore
linux @ hp

