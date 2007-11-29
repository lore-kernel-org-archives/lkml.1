Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbXK2SRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbXK2SRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932488AbXK2SRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:17:11 -0500
Received: from web94406.mail.in2.yahoo.com ([203.104.16.231]:23547 "HELO
	web94406.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932960AbXK2SRI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:17:08 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2007 13:17:07 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=veQWdj57JGhzxg0xcRHuO/ITR/pYBEWBb3gkRF+psxwf+7tMUupKCjURW8ZEr3kaeliatqsUQH9mxMfI0Jmw2mSzsaeKi6tmbhhpdSJCc1G5cL9mj0YM+zHVhTRpBOOvPaj3Qpbqj0ZQWIQ5+olfpGYaBfYUxzwGJ0YlgosmIr0=;
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.157
Date: Thu, 29 Nov 2007 23:40:23 +0530 (IST)
From: samarjit adhikari <adhikari_20022002@yahoo.com>
Subject: didn't find out implicit bind implementation from connect call.
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <31693.9968.qm@web94406.mail.in2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am a newbies to linux kernel. I was browsing the kernel code for 
TCP/IP implementation.I was looking into the implementation of
"tcp_v4_connect" function.

lets consider the following situation.
client side implementation:
---------------------------
int sockfd;
struct sockaddr_in sin_addr;

sockfd = socket(AF_INET,SOCK_STREAM,0);
...
//sin_addr has been populated by remote ip and port and AF_INET family.
//client didn't explicitly bind local addr/port
...
ret = connect(sockfd,(struct sockaddr*)sin_addr,sizeof(struct sockaddr_in));
...

As most of the tcp/ip books discuss that the kernel will implicitly bind 
local port/ip before actually send the SYN packet.


While looking into the "tcp_v4_connect" implementation i didn't figure out
which portion of the code is responsible for implicit local/ip port binding.

Any pointer will help me to understand the TCP/IP stack implementation better.

Thanx and regards,
Samarjit

(N.B. Please copy the response to this personal email)

The tcp_v4_connect implementation is as follows.(for linux kernel 2.6.23 patch 2.6.23.1)
---------------------------------------------------------------
/* This will initiate an outgoing connection. */
int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
{
        struct inet_sock *inet = inet_sk(sk);
        struct tcp_sock *tp = tcp_sk(sk);
        struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
        struct rtable *rt;
        __be32 daddr, nexthop;
        int tmp;
        int err;

        if (addr_len < sizeof(struct sockaddr_in))
                return -EINVAL;

        if (usin->sin_family != AF_INET)
                return -EAFNOSUPPORT;

        nexthop = daddr = usin->sin_addr.s_addr;
        if (inet->opt && inet->opt->srr) {
                if (!daddr)
                        return -EINVAL;
                nexthop = inet->opt->faddr;
        }

        tmp = ip_route_connect(&rt, nexthop, inet->saddr,
                               RT_CONN_FLAGS(sk), sk->sk_bound_dev_if,
                               IPPROTO_TCP,
                               inet->sport, usin->sin_port, sk, 1);
        if (tmp < 0) {
                if (tmp == -ENETUNREACH)
                        IP_INC_STATS_BH(IPSTATS_MIB_OUTNOROUTES);
                return tmp;
         }

        if (rt->rt_flags & (RTCF_MULTICAST | RTCF_BROADCAST)) {
                ip_rt_put(rt);
                return -ENETUNREACH;
        }

        if (!inet->opt || !inet->opt->srr)
                daddr = rt->rt_dst;

        if (!inet->saddr)
                inet->saddr = rt->rt_src;
        inet->rcv_saddr = inet->saddr;

        if (tp->rx_opt.ts_recent_stamp && inet->daddr != daddr) {
                /* Reset inherited state */
                tp->rx_opt.ts_recent       = 0;
                tp->rx_opt.ts_recent_stamp = 0;
                tp->write_seq              = 0;
        }

        if (tcp_death_row.sysctl_tw_recycle &&
            !tp->rx_opt.ts_recent_stamp && rt->rt_dst == daddr) {
                struct inet_peer *peer = rt_get_peer(rt);
                /*
                 * VJ's idea. We save last timestamp seen from
                 * the destination in peer table, when entering state
                 * TIME-WAIT * and initialize rx_opt.ts_recent from it,
                 * when trying new connection.
                 */
                if (peer != NULL &&
                    peer->tcp_ts_stamp + TCP_PAWS_MSL >= get_seconds()) {
                        tp->rx_opt.ts_recent_stamp = peer->tcp_ts_stamp;
                        tp->rx_opt.ts_recent = peer->tcp_ts;
                }
        }
        inet->dport = usin->sin_port;
        inet->daddr = daddr;

        inet_csk(sk)->icsk_ext_hdr_len = 0;
        if (inet->opt)
                inet_csk(sk)->icsk_ext_hdr_len = inet->opt->optlen;

        tp->rx_opt.mss_clamp = 536;

        /* Socket identity is still unknown (sport may be zero).
         * However we set state to SYN-SENT and not releasing socket
         * lock select source port, enter ourselves into the hash tables and
         * complete initialization after this.
         */
        tcp_set_state(sk, TCP_SYN_SENT);
        err = inet_hash_connect(&tcp_death_row, sk);
        if (err)
                goto failure;

        err = ip_route_newports(&rt, IPPROTO_TCP,
                                inet->sport, inet->dport, sk);
        if (err)
                goto failure;

        /* OK, now commit destination to socket.  */
        sk->sk_gso_type = SKB_GSO_TCPV4;
        sk_setup_caps(sk, &rt->u.dst);

        if (!tp->write_seq)
                tp->write_seq = secure_tcp_sequence_number(inet->saddr,
                                                           inet->daddr,
                                                           inet->sport,
                                                           usin->sin_port);

        inet->id = tp->write_seq ^ jiffies;

        err = tcp_connect(sk);
        rt = NULL;
        if (err)
                goto failure;

        return 0;

failure:
        /*
         * This unhashes the socket and releases the local port,
         * if necessary.
         */
        tcp_set_state(sk, TCP_CLOSE);
        ip_rt_put(rt);
        sk->sk_route_caps = 0;
        inet->dport = 0;
        return err;
}





      5, 50, 500, 5000 - Store N number of mails in your inbox. Go to http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html
