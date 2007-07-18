Return-Path: <linux-kernel-owner+w=401wt.eu-S935020AbXGRTlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935020AbXGRTlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbXGRTlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:41:16 -0400
Received: from web56608.mail.re3.yahoo.com ([66.196.97.52]:21076 "HELO
	web56608.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754613AbXGRTlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:41:15 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2007 15:41:15 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=UvJ/xvY8X48ZIr2PXYlZ5RVtyVpy8u2pc6hPbaXOUctuPgFaUp95jY7hdE1yai/eDtYMPENB/emVcjG35+HQGjGeaIECnQOtJMNm1q95pzENW5JV8VcRe3VgLwH9wnAnSdmOQ7ntXr72ddcfP/JcnnFtEqLndMhV0LOAASVVs+c=;
X-YMail-OSG: jgiUNPsVM1mRsqbp0EL39Igrk0B5BcIKjF6lG5MD3CthAsZexd4LuF4sP3leWtlsdBgl7eWR3RP35DTdTBJMcr1t_PeAAgiGIEx8wzuUEKgq4jlGoZJy9pnB.W8Clw--
X-Mailer: YahooMailRC/651.41 YahooMailWebService/0.7.41.16
Date: Wed, 18 Jul 2007 12:34:33 -0700 (PDT)
From: andrei radulescu-banu <iubica2@yahoo.com>
Subject: Linux, tcpdump and vlan
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <878246.51044.qm@web56608.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel networking gurus, 
  

I am trying to understand why tcpdump does not work properly for vlan packets on linux. Here is the existing behavior, observed with:
  - kernel 2.6.16,   
- e1000 driver  
- libpcap 0.9.6  
- tcpdump 3.9.6 
  

The e1000 driver has two modes when handling vlan frames:  
(A) Default mode, when   
- on rx, the mac includes vlan headers   
- on tx, the mac expects tx frames to include vlan headers.   
(B) Vlan hw accelerated mode, when:  
- on rx, the mac does not include vlan headers, and instead passes vlan tag information in the status field of the ring buffer
  - on tx, the mac expects no vlan headers, and instead expects vlan tag information to be passed in the status field of the ring buffer
  

If no vlan interfaces are used, the e1000 driver configures the mac in default mode (A). The system will only receive vlan traffic, and not transmit any. Tcpdump then gets the entire rx vlan buffers, and displays them correctly.
  

Suppose now that at least one vlan interface is used - say eth0 is the main physical interface, and eth0.2 is an interface created on vlan id 2. The e1000 driver then switches to vlan hw accelerated mode (B). Furthermore, even if set promiscuous, the e1000 will filter out any rx vlan frames of id other than 2, which breaks tcpdump (bug 1).
  

Suppose in our scenario with eth0 and eth0.2 we're running tcpdump on eth0 - which uses a packet socket. The rx vlan frames with id 2 are then assigned by the driver to eth0.2, and are therefore not passed to the packet socket and to tcpdump (bug 2). The tx vlan frames on eth0.2 are passed to the packet socket without any vlan information, and tcpdump does not display the vlan header (bug 3)
  

In conclusion, here is the buglist:  
1). If set promiscuous, the e1000 should disable any vlan rx filtering, so that it can receive vlan frames of other vlan id's. Other ethernet drivers probably need fixed as well.
  2). The packet layer should change the rx skb device from the vlan 'fake' device (eth0.2) to the corresponding physical device (eth0), so when we run tcpdump on eth0 we see all vlan-tagged and non-vlan-tagged frames
  3). The packet socket layer should insert the vlan tag header before passing frames to the upper layer, so tcpdump can display them.
  

Open issue:  
4). What is the expected behavior when running 'tcpdump -I eth0.2'? Perhaps the packet socket should silently display all frames on eth0, so running 'tcpdump -i eth0' is equivalent to 'tcpdump -i eth0.2'

  

Thoughts? Comments? Please cc iubica2@yahoo.com, I am not subscribed. 
  

Andrei Radulescu-Banu  
Brix Networks 





      ____________________________________________________________________________________
Luggage? GPS? Comic books? 
Check out fitting gifts for grads at Yahoo! Search
http://search.yahoo.com/search?fr=oni_on_mail&p=graduation+gifts&cs=bz
