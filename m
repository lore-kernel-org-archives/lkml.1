Return-Path: <linux-kernel-owner+w=401wt.eu-S932857Ab0AFVS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab0AFVS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932685Ab0AFVS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:18:58 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:51231 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab0AFVS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:18:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=B8oWyaeVvhmtobWo6rDtf5iqw2bx7JiHvbwKVFde8AkebPBizrM0+6N/ILtHFOwi5+
         pH5V3PtrSyO8/cyRe42FXNKHhxoAtqvepViz9El3I9XE20tkgWsRUPY1sFy7boERxmf0
         tUWFhL+MeJp9xLZrs1HVKGUmTkH71tHY/xEdw=
Message-ID: <4B44FE3C.6060809@gmail.com>
Date: Wed, 06 Jan 2010 16:18:52 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>
CC: Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>
Subject: [PATCH 0/2] net: replace buggy tcp_optlen, and cleanup
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bugginess was reported in October, November, December, and
January.  I'm requesting some independent review and testing.

The tcp_optlen() function returns a potential *negative* unsigned:

-static inline unsigned int tcp_optlen(const struct sk_buff *skb)
-{
-	return (tcp_hdr(skb)->doff - 5) * 4;
-}
-

This is replaced by tcp_header_len_th() and tcp_option_len_th().

The tcp_optlen() function is used *only* in two drivers, that
also have rather messy coding practices; such as:

-	if ((mss = skb_shinfo(skb)->gso_size)) {
...
-	} else
-		mss = 0;

Or:

-	mss = 0;
-	if ((mss = skb_shinfo(skb)->gso_size) != 0) {

Or:

-			iph->tot_len = htons(mss + ip_tcp_len + tcp_opt_len);
-			hdrlen = ip_tcp_len + tcp_opt_len;

Or mixing word and byte sized variables, without using defined constants
or useful sizeof() to make the code self-documenting:

-			if (tcp_opt_len || (iph->ihl > 5)) {
-				vlan_tag_flags |= ((iph->ihl - 5) +
-						   (tcp_opt_len >> 2)) << 8;
-			}

Stand-alone patch, originally developed for TCPCT.

Signed-off-by: William.Allen.Simpson@gmail.com
