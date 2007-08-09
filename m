Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbXHISu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbXHISu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbXHIStz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:49:55 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:32843 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbXHISty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:49:54 -0400
Message-ID: <46BB61D0.4090101@opengridcomputing.com>
Date: Thu, 09 Aug 2007 13:49:52 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>, "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Sean Hefty <sean.hefty@intel.com>,
       OpenFabrics General <general@lists.openfabrics.org>
Subject: Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports from the host TCP
 port space.
References: <46B883B5.8040702@opengridcomputing.com>
In-Reply-To: <46B883B5.8040702@opengridcomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Any more comments?


Steve Wise wrote:
> Networking experts,
> 
> I'd like input on the patch below, and help in solving this bug 
> properly.  iWARP devices that support both native stack TCP and iWARP 
> (aka RDMA over TCP/IP/Ethernet) connections on the same interface need 
> the fix below or some similar fix to the RDMA connection manager.
> 
> This is a BUG in the Linux RDMA-CMA code as it stands today.
> 
> Here is the issue:
> 
> Consider an mpi cluster running mvapich2.  And the cluster runs 
> MPI/Sockets jobs concurrently with MPI/RDMA jobs.  It is possible, 
> without the patch below, for MPI/Sockets processes to mistakenly get 
> incoming RDMA connections and vice versa.  The way mvapich2 works is 
> that the ranks all bind and listen to a random port (retrying new random 
> ports if the bind fails with "in use").  Once they get a free port and
> bind/listen, they advertise that port number to the peers to do 
> connection setup.  Currently, without the patch below, the mpi/rdma 
> processes can end up binding/listening to the _same_ port number as the 
> mpi/sockets processes running over the native tcp stack.  This is due to 
> duplicate port spaces for native stack TCP and the rdma cm's RDMA_PS_TCP 
> port space.  If this happens, then the connections can get screwed up.
> 
> The correct solution in my mind is to use the host stack's TCP port 
> space for _all_ RDMA_PS_TCP port allocations.   The patch below is a 
> minimal delta to unify the port spaces by using the kernel stack to bind 
> ports.  This is done by allocating a kernel socket and binding to the 
> appropriate local addr/port.  It also allows the kernel stack to pick 
> ephemeral ports by virtue of just passing in port 0 on the kernel bind 
> operation.
> 
> There has been a discussion already on the RDMA list if anyone is 
> interested:
> 
> http://www.mail-archive.com/general@lists.openfabrics.org/msg05162.html
> 
> 
> Thanks,
> 
> Steve.
> 
> 
> ---
> 
> RDMA/CMA: Allocate PS_TCP ports from the host TCP port space.
> 
> This is needed for iwarp providers that support native and rdma
> connections over the same interface.
> 
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
> 
> drivers/infiniband/core/cma.c |   27 ++++++++++++++++++++++++++-
> 1 files changed, 26 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 9e0ab04..e4d2d7f 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -111,6 +111,7 @@ struct rdma_id_private {
>     struct rdma_cm_id    id;
> 
>     struct rdma_bind_list    *bind_list;
> +    struct socket        *sock;
>     struct hlist_node    node;
>     struct list_head    list;
>     struct list_head    listen_list;
> @@ -695,6 +696,8 @@ static void cma_release_port(struct rdma
>         kfree(bind_list);
>     }
>     mutex_unlock(&lock);
> +    if (id_priv->sock)
> +        sock_release(id_priv->sock);
> }
> 
> void rdma_destroy_id(struct rdma_cm_id *id)
> @@ -1790,6 +1793,25 @@ static int cma_use_port(struct idr *ps,
>     return 0;
> }
> 
> +static int cma_get_tcp_port(struct rdma_id_private *id_priv)
> +{
> +    int ret;
> +    struct socket *sock;
> +
> +    ret = sock_create_kern(AF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
> +    if (ret)
> +        return ret;
> +    ret = sock->ops->bind(sock,
> +              (struct sockaddr *)&id_priv->id.route.addr.src_addr,
> +              ip_addr_size(&id_priv->id.route.addr.src_addr));
> +    if (ret) {
> +        sock_release(sock);
> +        return ret;
> +    }
> +    id_priv->sock = sock;
> +    return 0;   
> +}
> +
> static int cma_get_port(struct rdma_id_private *id_priv)
> {
>     struct idr *ps;
> @@ -1801,6 +1823,9 @@ static int cma_get_port(struct rdma_id_p
>         break;
>     case RDMA_PS_TCP:
>         ps = &tcp_ps;
> +        ret = cma_get_tcp_port(id_priv); /* Synch with native stack */
> +        if (ret)
> +            goto out;
>         break;
>     case RDMA_PS_UDP:
>         ps = &udp_ps;
> @@ -1815,7 +1840,7 @@ static int cma_get_port(struct rdma_id_p
>     else
>         ret = cma_use_port(ps, id_priv);
>     mutex_unlock(&lock);
> -
> +out:
>     return ret;
> }
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
