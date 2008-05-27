Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbYE0GAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbYE0GAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYE0GAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:00:38 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:1851 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYE0GAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pUNzS23YqbMlztagICmKHebWMOfow4EPQz5VLdJhdKpwRJaUAnDtK0J4Ukt6/THet/rlT3sP+arCAj6zgtYPWY0MFFP9feG99l3tg6oXY6ZHc4gVXyCdR+GfLxWtKFCB4XZ7eS1SBpqCZVD3Z1KHCWrWdyY6NbBiN2Ae1xgtodA=
Message-ID: <84ee89da0805262300v747c712ayfb60ac8aa790edb7@mail.gmail.com>
Date: Tue, 27 May 2008 12:00:35 +0600
From: "Dmitry Petukhov" <dmgenp@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: possible double call of kfree_skb in net/llc/llc_sap.c
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the file  net/llc/llc_sap.c, funcion llc_sap_state_process,
the call to kfree_skb in the line 227 can proceed even if skb was already freed
on line 218, or  224, or queued to the user within sock_queue_rcv_skb function.
Obviously return statement is missing after line 225.

This problem was found by Alex Shevkov.

the code in question:

204 static void llc_sap_state_process(struct llc_sap *sap, struct sk_buff *skb)
205 {
206         struct llc_sap_state_ev *ev = llc_sap_ev(skb);
207
....
213         skb_get(skb);
214         ev->ind_cfm_flag = 0;
215         llc_sap_next_state(sap, skb);
216         if (ev->ind_cfm_flag == LLC_IND) {
217                 if (skb->sk->sk_state == TCP_LISTEN)
218                         kfree_skb(skb);
219                 else {
220                         llc_save_primitive(skb->sk, skb, ev->prim);
221
222                         /* queue skb to the user. */
223                         if (sock_queue_rcv_skb(skb->sk, skb))
224                                 kfree_skb(skb);
225                 }
226         }
227         kfree_skb(skb);
228 }
