Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYAHPlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYAHPlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 10:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYAHPlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 10:41:40 -0500
Received: from web707.biz.mail.mud.yahoo.com ([209.191.119.232]:23099 "HELO
	web707.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753413AbYAHPli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:41:38 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 10:41:38 EST
X-YMail-OSG: MGgJPtUVM1nuh.xuC2JSQD.fA6G3qmZ2qGfgwJi1ClG.j9ZcMNfOW0A0nKtUryaxVA--
Date: Tue, 8 Jan 2008 10:34:58 -0500 (EST)
From: Jon Paul Maloy <maloy@donjonn.com>
Reply-To: maloy@donjonn.com
Subject: RE : [tipc-discussion] /net/tipc/port.c: Use tipc_port_unlock
To: Julia Lawall <julia@diku.dk>, per.liden@ericsson.com,
       jon.maloy@ericsson.com, allan.stephens@windriver.com,
       tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0801041546220.1184@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <335603.50794.qm@web707.biz.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no objections.
///jon

--- Julia Lawall <julia@diku.dk> a écrit :

> From: Julia Lawall <julia@diku.dk>
> 
> The file net/tipc/port.c takes a lock using the
> function tipc_port_lock and
> then releases the lock sometimes using
> tipc_port_unlock and sometimes using
> spin_unlock_bh(p_ptr->publ.lock).  tipc_port_unlock
> simply does the
> spin_unlock_bh, but it seems cleaner to use it
> everywhere.
> 
> 
> The problem was fixed using the following semantic
> patch.
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> struct port *p_ptr;
> @@
> 
>    p_ptr = tipc_port_lock(...)
>    ...
> (
>    p_ptr = tipc_port_lock(...);
> |
> ?- spin_unlock_bh(p_ptr->publ.lock);
> +  tipc_port_unlock(p_ptr);
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
> 
> diff -u -p a/net/tipc/port.c b/net/tipc/port.c
> --- a/net/tipc/port.c 2008-01-01 10:43:55.000000000
> +0100
> +++ b/net/tipc/port.c 2008-01-04 10:51:05.000000000
> +0100
> @@ -340,7 +340,7 @@ int tipc_portunreliable(u32 ref,
> unsigne
>  	if (!p_ptr)
>  		return -EINVAL;
>  	*isunreliable = port_unreliable(p_ptr);
> -	spin_unlock_bh(p_ptr->publ.lock);
> +	tipc_port_unlock(p_ptr);
>  	return TIPC_OK;
>  }
> 
> @@ -369,7 +369,7 @@ int tipc_portunreturnable(u32
> ref, unsig
>  	if (!p_ptr)
>  		return -EINVAL;
>  	*isunrejectable = port_unreturnable(p_ptr);
> -	spin_unlock_bh(p_ptr->publ.lock);
> +	tipc_port_unlock(p_ptr);
>  	return TIPC_OK;
>  }
> 
> @@ -843,7 +843,7 @@ static void
> port_dispatcher_sigh(void *d
>  				u32 peer_port = port_peerport(p_ptr);
>  				u32 peer_node = port_peernode(p_ptr);
> 
> -				spin_unlock_bh(p_ptr->publ.lock);
> +				tipc_port_unlock(p_ptr);
>  				if (unlikely(!connected)) {
>  					if (unlikely(published))
>  						goto reject;
> @@ -867,7 +867,7 @@ static void
> port_dispatcher_sigh(void *d
>  		case TIPC_DIRECT_MSG:{
>  				tipc_msg_event cb = up_ptr->msg_cb;
> 
> -				spin_unlock_bh(p_ptr->publ.lock);
> +				tipc_port_unlock(p_ptr);
>  				if (unlikely(connected))
>  					goto reject;
>  				if (unlikely(!cb))
> @@ -882,7 +882,7 @@ static void
> port_dispatcher_sigh(void *d
>  		case TIPC_NAMED_MSG:{
>  				tipc_named_msg_event cb = up_ptr->named_msg_cb;
> 
> -				spin_unlock_bh(p_ptr->publ.lock);
> +				tipc_port_unlock(p_ptr);
>  				if (unlikely(connected))
>  					goto reject;
>  				if (unlikely(!cb))
> @@ -913,7 +913,7 @@ err:
>  				u32 peer_port = port_peerport(p_ptr);
>  				u32 peer_node = port_peernode(p_ptr);
> 
> -				spin_unlock_bh(p_ptr->publ.lock);
> +				tipc_port_unlock(p_ptr);
>  				if (!connected || !cb)
>  					break;
>  				if (msg_origport(msg) != peer_port)
> @@ -929,7 +929,7 @@ err:
>  		case TIPC_DIRECT_MSG:{
>  				tipc_msg_err_event cb = up_ptr->err_cb;
> 
> -				spin_unlock_bh(p_ptr->publ.lock);
> +				tipc_port_unlock(p_ptr);
>  				if (connected || !cb)
>  					break;
>  				skb_pull(buf, msg_hdr_sz(msg));
> @@ -942,7 +942,7 @@ err:
>  				tipc_named_msg_err_event cb =
>  					up_ptr->named_err_cb;
> 
> -				spin_unlock_bh(p_ptr->publ.lock);
> +				tipc_port_unlock(p_ptr);
>  				if (connected || !cb)
>  					break;
>  				dseq.type =  msg_nametype(msg);
> @@ -1107,7 +1107,7 @@ int tipc_portimportance(u32
> ref, unsigne
>  	if (!p_ptr)
>  		return -EINVAL;
>  	*importance = (unsigned
> int)msg_importance(&p_ptr->publ.phdr);
> -	spin_unlock_bh(p_ptr->publ.lock);
> +	tipc_port_unlock(p_ptr);
>  	return TIPC_OK;
>  }
> 
> @@ -1122,7 +1122,7 @@ int
> tipc_set_portimportance(u32 ref, uns
>  	if (!p_ptr)
>  		return -EINVAL;
>  	msg_set_importance(&p_ptr->publ.phdr, (u32)imp);
> -	spin_unlock_bh(p_ptr->publ.lock);
> +	tipc_port_unlock(p_ptr);
>  	return TIPC_OK;
>  }
> 
> 
>
-------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio
> 2005.
>
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> tipc-discussion mailing list
> tipc-discussion@lists.sourceforge.net
>
https://lists.sourceforge.net/lists/listinfo/tipc-discussion
> 

