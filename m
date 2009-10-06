Return-Path: <linux-kernel-owner+w=401wt.eu-S933446AbZJFWSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446AbZJFWSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933318AbZJFWSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:18:55 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:40985 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933078AbZJFWSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:18:52 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 1/4] Documentation: expand isdn/INTERFACE.CAPI document
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
CC: Karsten Keil <isdn@linux-pingi.de>, Karsten Keil <keil@b1-systems.de>,
       isdn4linux@listserv.isdn4linux.de, i4ldeveloper@listserv.isdn4linux.de
Message-ID: <20091006-patch-capi-1.tilman@imap.cc>
In-Reply-To: <20091006-patch-capi-0.tilman@imap.cc>
References: <20091006-patch-capi-0.tilman@imap.cc>
Date: Wed,  7 Oct 2009 00:18:00 +0200 (CEST)
X-Spam-Score: -2.126 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Note that send_message() may be called in interrupt context.
- Describe the storage of CAPI messages and payload data in SKBs.
- Add more details to the description of the _cmsg structure.
- Describe kernelcapi debugging output.

Impact: documentation
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 Documentation/isdn/INTERFACE.CAPI |   83 +++++++++++++++++++++++++++++-------
 1 files changed, 67 insertions(+), 16 deletions(-)

diff --git a/Documentation/isdn/INTERFACE.CAPI b/Documentation/isdn/INTERFACE.CAPI
index 686e107..5fe8de5 100644
--- a/Documentation/isdn/INTERFACE.CAPI
+++ b/Documentation/isdn/INTERFACE.CAPI
@@ -60,10 +60,9 @@ open() operation on regular files or character devices.
 
 After a successful return from register_appl(), CAPI messages from the
 application may be passed to the driver for the device via calls to the
-send_message() callback function. The CAPI message to send is stored in the
-data portion of an skb. Conversely, the driver may call Kernel CAPI's
-capi_ctr_handle_message() function to pass a received CAPI message to Kernel
-CAPI for forwarding to an application, specifying its ApplID.
+send_message() callback function. Conversely, the driver may call Kernel
+CAPI's capi_ctr_handle_message() function to pass a received CAPI message to
+Kernel CAPI for forwarding to an application, specifying its ApplID.
 
 Deregistration requests (CAPI operation CAPI_RELEASE) from applications are
 forwarded as calls to the release_appl() callback function, passing the same
@@ -142,6 +141,7 @@ u16  (*send_message)(struct capi_ctr *ctrlr, struct sk_buff *skb)
 	to accepting or queueing the message. Errors occurring during the
 	actual processing of the message should be signaled with an
 	appropriate reply message.
+	May be called in process or interrupt context.
 	Calls to this function are not serialized by Kernel CAPI, ie. it must
 	be prepared to be re-entered.
 
@@ -154,7 +154,8 @@ read_proc_t *ctr_read_proc
 	system entry, /proc/capi/controllers/<n>; will be called with a
 	pointer to the device's capi_ctr structure as the last (data) argument
 
-Note: Callback functions are never called in interrupt context.
+Note: Callback functions except send_message() are never called in interrupt
+context.
 
 - to be filled in before calling capi_ctr_ready():
 
@@ -171,14 +172,40 @@ u8 serial[CAPI_SERIAL_LEN]
 	value to return for CAPI_GET_SERIAL
 
 
-4.3 The _cmsg Structure
+4.3 SKBs
+
+CAPI messages are passed between Kernel CAPI and the driver via send_message()
+and capi_ctr_handle_message(), stored in the data portion of a socket buffer
+(skb).  Each skb contains a single CAPI message coded according to the CAPI 2.0
+standard.
+
+For the data transfer messages, DATA_B3_REQ and DATA_B3_IND, the actual
+payload data immediately follows the CAPI message itself within the same skb.
+The Data and Data64 parameters are not used for processing. The Data64
+parameter may be omitted by setting the length field of the CAPI message to 22
+instead of 30.
+
+
+4.4 The _cmsg Structure
 
 (declared in <linux/isdn/capiutil.h>)
 
 The _cmsg structure stores the contents of a CAPI 2.0 message in an easily
-accessible form. It contains members for all possible CAPI 2.0 parameters, of
-which only those appearing in the message type currently being processed are
-actually used. Unused members should be set to zero.
+accessible form. It contains members for all possible CAPI 2.0 parameters,
+including subparameters of the Additional Info and B Protocol structured
+parameters, with the following exceptions:
+
+* second Calling party number (CONNECT_IND)
+
+* Data64 (DATA_B3_REQ and DATA_B3_IND)
+
+* Sending complete (subparameter of Additional Info, CONNECT_REQ and INFO_REQ)
+
+* Global Configuration (subparameter of B Protocol, CONNECT_REQ, CONNECT_RESP
+  and SELECT_B_PROTOCOL_REQ)
+
+Only those parameters appearing in the message type currently being processed
+are actually used. Unused members should be set to zero.
 
 Members are named after the CAPI 2.0 standard names of the parameters they
 represent. See <linux/isdn/capiutil.h> for the exact spelling. Member data
@@ -190,18 +217,19 @@ u16         for CAPI parameters of type 'word'
 
 u32         for CAPI parameters of type 'dword'
 
-_cstruct    for CAPI parameters of type 'struct' not containing any
-	    variably-sized (struct) subparameters (eg. 'Called Party Number')
+_cstruct    for CAPI parameters of type 'struct'
 	    The member is a pointer to a buffer containing the parameter in
 	    CAPI encoding (length + content). It may also be NULL, which will
 	    be taken to represent an empty (zero length) parameter.
+	    Subparameters are stored in encoded form within the content part.
 
-_cmstruct   for CAPI parameters of type 'struct' containing 'struct'
-	    subparameters ('Additional Info' and 'B Protocol')
+_cmstruct   alternative representation for CAPI parameters of type 'struct'
+	    (used only for the 'Additional Info' and 'B Protocol' parameters)
 	    The representation is a single byte containing one of the values:
-	    CAPI_DEFAULT: the parameter is empty
-	    CAPI_COMPOSE: the values of the subparameters are stored
-	    individually in the corresponding _cmsg structure members
+	    CAPI_DEFAULT: The parameter is empty/absent.
+	    CAPI_COMPOSE: The parameter is present.
+	    Subparameter values are stored individually in the corresponding
+	    _cmsg structure members.
 
 Functions capi_cmsg2message() and capi_message2cmsg() are provided to convert
 messages between their transport encoding described in the CAPI 2.0 standard
@@ -297,3 +325,26 @@ char *capi_cmd2str(u8 Command, u8 Subcommand)
 	be NULL if the command/subcommand is not one of those defined in the
 	CAPI 2.0 standard.
 
+
+7. Debugging
+
+The module kernelcapi has a module parameter showcapimsgs controlling some
+debugging output produced by the module. It can only be set when the module is
+loaded, via a parameter "showcapimsgs=<n>" to the modprobe command, either on
+the command line or in the configuration file.
+
+If the lowest bit of showcapimsgs is set, kernelcapi logs controller and
+application up and down events.
+
+In addition, every registered CAPI controller has an associated traceflag
+parameter controlling how CAPI messages sent from and to tha controller are
+logged. The traceflag parameter is initialized with the value of the
+showcapimsgs parameter when the controller is registered, but can later be
+changed via the MANUFACTURER_REQ command KCAPI_CMD_TRACE.
+
+If the value of traceflag is non-zero, CAPI messages are logged.
+DATA_B3 messages are only logged if the value of traceflag is > 2.
+
+If the lowest bit of traceflag is set, only the command/subcommand and message
+length are logged. Otherwise, kernelcapi logs a readable representation of
+the entire message.
-- 
1.6.2.1.214.ge986c

