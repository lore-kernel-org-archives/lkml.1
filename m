Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab0BLX3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 18:29:00 -0500
Received: from web63405.mail.re1.yahoo.com ([69.147.97.45]:23349 "HELO
	web63405.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755980Ab0BLX25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 18:28:57 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Feb 2010 18:28:57 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=h3RYK7pfVFUDoaMIxYy/cEv3cj6GziHqHZMMFlBBQ+x9GaS/GO3t7uPg0tkpyC0OybkEneSiqAtisJdXvxzVyKYLPUvhf1w9t7FLyHkGc3UulcqdEkJ5spEG0yetN68g5bmCs86wbNly0gmXEQ7PVYVi/DbKMJpukQGZKixNvAE=;
Message-ID: <157135.69931.qm@web63405.mail.re1.yahoo.com>
X-YMail-OSG: PD2pUhoVM1lQ7e9ZyaioD51saQYo9xacHb6GZS0a_0BYf34UVcPxGznBW90lSBi6VGGdobplSS0oH8AtDlFFDq.X6KF35YF5AiaPc.CfH.02oS3kGNM00pX2EdYa.d1GsQx5FCwQFLYVO6ygA0wHCUOmWepvXrUOjRFZjgE.nfl8GTrQ82YL3slIKZmRxlMV2zr5g61NLm3vZgjfTV9ni1LdqNd2kfo4jRagUWSdkJwPWleeUQZHt1mc05yJ86_o1YON.Z.t0hqOqepuvBCJ9Og3PafhcshfrAOxRTP4ij0m32N3_voI3Q7fZ_KJc4eiCODX
X-Mailer: YahooMailClassic/9.1.10 YahooMailWebService/0.8.100.260964
Date: Fri, 12 Feb 2010 15:22:16 -0800 (PST)
From: Joe Cao <caoco2002@yahoo.com>
Subject: bug and question in tcp stack
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think it is an obvious bug both in the old and latest kernel:

In function net/ipv4/tcp_output.c, tcp_retransmit_skb() returns a NEGTIVE value on failures.  But in net/ipv4/tcp_timer.c, in function tcp_retransmit_timer(), the line

if (tcp_retransmit_skb(sk, tcp_write_queue_head(sk)) > 0) {

checks the return value as a positive number, which will never be true.  On failures from tcp_retransmit_skb(), the code will follow the wrong path.

My second question is regarding the function tcp_retransmit_skb().  The first check in the function is copied here:

 	/* Do not sent more than we queued. 1/4 is reserved for possible
	 * copying overhead: fragmentation, tunneling, mangling etc.
	 */
	if (atomic_read(&sk->sk_wmem_alloc) >
	    min(sk->sk_wmem_queued + (sk->sk_wmem_queued >> 2), sk->sk_sndbuf))
		return -EAGAIN;


My question is if that turns out to be true, which I saw happend, how could the stack get out of the state?  Because all TCP retransmission may fail, no buffer will be released.  The connection is virtually dead.  Is that true?

Thanks,
Joe


      
