Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707Ab0ASTf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0ASTf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462Ab0ASTfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:35:25 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:62759 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab0ASTfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:35:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qRZ1iz9oXxGwhPccZHd7+pBxspF03pquh2IZp3RN/pbepmGQNlmkm/rBqosSNvFfIo
         7b7sb/8PT5zn82XpcFMKxohC6mZIh3137FQM4kGmfF/972TuGg77Bh+JgtqdgrfAcwod
         YsByCT0GVijFsuSk2vqiSticRUU11W/hNyNag=
Message-ID: <4B560978.8080707@gmail.com>
Date: Tue, 19 Jan 2010 14:35:20 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>
CC: Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2] tcp: input header length, prediction, and timestamp
 bugs
References: <4B49C2D0.1070704@gmail.com> <4B50BFFC.8010108@gmail.com> <4B55ED46.40909@gmail.com>
In-Reply-To: <4B55ED46.40909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson wrote:
> Therefore, I'll resubmit this patch, removing the existing len parameter.
> And maybe *th, too....
> 
Just to quickly note that gcc 4.4 doesn't properly remember that it has
already loaded *th with this rampant use of an inline function (unlike the
older macro method):

c04ea739:	89 d3                	mov    %edx,%ebx

static inline struct tcphdr *tcp_hdr(const struct sk_buff *skb)
{
	return (struct tcphdr *)skb_transport_header(skb);
c04ea743:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
	 *
	 *	Our current scheme is not silly either but we take the
	 *	extra cost of the net_bh soft interrupt processing...
	 *	We do checksum and copy also but from device to kernel.
	 */
	if ((tcp_flag_word(tcp_hdr(skb)) & TCP_HP_BITS) == tp->pred_flags &&
...


Note that the index is in both %edx and %ebx, but it uses replaced %edx.
Although by inspection that result stays in %edx, it reloaded twice more:

	res = tcp_validate_incoming(sk, skb, tcp_hdr(skb), 1);
c04ea78c:	8b 8b 94 00 00 00    	mov    0x94(%ebx),%ecx
c04ea792:	89 da                	mov    %ebx,%edx
c04ea794:	89 f0                	mov    %esi,%eax
c04ea796:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c04ea79d:	e8 0e c3 ff ff       	call   c04e6ab0 <tcp_validate_incoming>
	if (res <= 0)
c04ea7a2:	85 c0                	test   %eax,%eax
c04ea7a4:	0f 8e 8e 03 00 00    	jle    c04eab38 <tcp_rcv_established+0x408>

#else /* NET_SKBUFF_DATA_USES_OFFSET */

static inline unsigned char *skb_transport_header(const struct sk_buff *skb)
{
	return skb->transport_header;
c04ea7aa:	8b 83 94 00 00 00    	mov    0x94(%ebx),%eax
c04ea7b0:	f6 40 0d 10          	testb  $0x10,0xd(%eax)
c04ea7b4:	0f 85 5e 03 00 00    	jne    c04eab18 <tcp_rcv_established+0x3e8>


This doesn't happen with the parameter *th (undisturbed in %edi):

c04ea78a:	89 f9                	mov    %edi,%ecx
c04ea78c:	89 f2                	mov    %esi,%edx
c04ea78e:	89 d8                	mov    %ebx,%eax
c04ea790:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c04ea797:	e8 14 c3 ff ff       	call   c04e6ab0 <tcp_validate_incoming>
	if (res <= 0)
c04ea79c:	85 c0                	test   %eax,%eax
c04ea79e:	0f 8e 8c 03 00 00    	jle    c04eab30 <tcp_rcv_established+0x400>
		return -res;

step5:
	if (th->ack && tcp_ack(sk, skb, FLAG_SLOWPATH) < 0)
c04ea7a4:	f6 47 0d 10          	testb  $0x10,0xd(%edi)
c04ea7a8:	0f 85 62 03 00 00    	jne    c04eab10 <tcp_rcv_established+0x3e0>


Therefore, keeping the parameter *th.
